import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';
import 'package:abolashin/features/cart/presentation/manager/cart_state.dart';
import 'package:abolashin/features/checkout/data/datasource/checkout_data_source.dart';
import 'package:abolashin/features/checkout/data/model/sales_basket.dart';
import 'package:abolashin/features/products/data/datasource/products_data_source.dart';
import 'package:abolashin/features/products/data/model/product_details_model.dart';
import 'package:abolashin/features/products/presentation/widgets/product_units.dart';

export 'package:abolashin/features/cart/data/datasource/cart_local_data_source.dart'
    show cartBox, cartKey;

/// The local cart is shown and persisted on this device. For a signed-in
/// customer the Sales Basket is the source of truth: [syncWithServer] only
/// reads it and rewrites the local cart from it, while explicit add/remove
/// actions send one Add/Delete call per unit (the basket keeps one quantity
/// per product, not per sales unit).
class CartCubit extends Cubit<CartState> {
  CartCubit({
    CartLocalDataSource? dataSource,
    CheckoutDataSource? basket,
    ProductsDataSource? products,
  }) : _dataSource = dataSource ?? getIt<CartLocalDataSource>(),
       _basket = basket ?? getIt<CheckoutDataSource>(),
       _products = products ?? getIt<ProductsDataSource>(),
       super(CartInitial()) {
    _loaded = _loadCartItems();
  }

  final CartLocalDataSource _dataSource;
  final CheckoutDataSource _basket;
  final ProductsDataSource _products;

  late final Future<void> _loaded;

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  /// The cart line for [barcode]. A line keeps its instance until it changes,
  /// so a widget selecting it rebuilds only for its own changes.
  CartItem? lineWithBarcode(String barcode) =>
      _lineWithBarcode(_cartItems, barcode);

  // The refresh in progress; opening the cart again joins it.
  Future<void>? _sync;

  // Products whose details were loaded since the cart was last cleared. Later
  // refreshes take their quantity, stock and image from the basket and skip
  // the per-product details request.
  final Set<int> _detailsLoaded = {};

  // Products changed locally since the current refresh read the basket, or
  // whose Add/Delete calls are still running: the basket response may not
  // include those changes yet, so a refresh keeps their local lines.
  final Set<int> _changedSinceFetch = {};
  final Map<int, int> _callsInFlight = {};

  // Bumped when the cart is cleared, so late responses for a previous
  // customer are ignored.
  int _session = 0;

  Future<void> _loadCartItems() async {
    emit(CartLoading());
    final result = await _dataSource.readItems();
    if (isClosed) return;
    result.fold((failure) => emit(CartFailure(failure)), (items) {
      _cartItems
        ..clear()
        ..addAll(items);
      emit(CartAddItemSuccess());
    });
  }

  int getItemCount({
    required int productId,
    required String nameAr,
    required String nameEn,
    required String barcode,
    required double price,
    required double priceAfterDiscount,
    required String image,
    required num stockQuantity,
    required num customerQuantity,
  }) {
    final item = _cartItems.firstWhere(
      (item) => item.barcode == barcode,
      orElse:
          () => CartItem(
            productId: productId,
            nameAr: nameAr,
            nameEn: nameEn,
            barcode: barcode,
            priceBeforeDiscount: price,
            priceAfterDiscount: priceAfterDiscount,
            image: image,
            stockQuantity: stockQuantity,
            customerQuantity: customerQuantity,
            quantity: 0,
          ),
    );
    return item.quantity;
  }

  double calculateTotalPrice() {
    return _cartItems.fold(
      0.0,
      (total, item) => total + item.quantity * item.priceAfterDiscount,
    );
  }

  Future<void> addItem(CartItem newItem) async {
    emit(CartLoading());
    final index = _cartItems.indexWhere(
      (item) => item.barcode == newItem.barcode,
    );

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
        customerQuantity: _cartItems[index].customerQuantity,
      );
    } else {
      _cartItems.add(newItem.copyWith(quantity: 1));
    }

    final result = await _dataSource.saveItems(_cartItems);
    if (isClosed) return;
    final saved = result.fold((failure) {
      emit(CartFailure(failure));
      return false;
    }, (_) => true);
    if (!saved) return;
    emit(CartAddItemSuccess());
    await _sendToBasket(newItem, 1);
  }

  Future<void> removeItem(String barcode) async {
    emit(CartLoading());
    final index = _cartItems.indexWhere((item) => item.barcode == barcode);
    if (index == -1) {
      emit(CartRemoveItemSuccess());
      return;
    }
    final line = _cartItems[index];
    if (line.quantity > 1) {
      _cartItems[index] = line.copyWith(quantity: line.quantity - 1);
    } else {
      _cartItems.removeAt(index);
    }

    final result = await _dataSource.saveItems(_cartItems);
    if (isClosed) return;
    final saved = result.fold((failure) {
      emit(CartFailure(failure));
      return false;
    }, (_) => true);
    if (!saved) return;
    emit(CartRemoveItemSuccess());
    await _sendToBasket(line, -1);
  }

  ({int index, CartItem item})? deleteItem(String barcode) {
    final index = _cartItems.indexWhere((item) => item.barcode == barcode);
    if (index == -1) return null;
    final item = _cartItems.removeAt(index);
    emit(CartLoading());
    _persist(CartRemoveItemSuccess());
    _sendToBasket(item, -item.quantity);
    return (index: index, item: item);
  }

  void restoreItem(int index, CartItem item) {
    if (_cartItems.any((existing) => existing.barcode == item.barcode)) return;
    _cartItems.insert(index.clamp(0, _cartItems.length), item);
    emit(CartLoading());
    _persist(CartAddItemSuccess());
    _sendToBasket(item, item.quantity);
  }

  Future<void> _persist(CartState success) async {
    final result = await _dataSource.saveItems(_cartItems);
    if (isClosed) return;
    result.fold((failure) => emit(CartFailure(failure)), (_) => emit(success));
  }

  Future<void> clearCart() async {
    _session++;
    _changedSinceFetch.clear();
    _callsInFlight.clear();
    _detailsLoaded.clear();
    _cartItems.clear();
    await _dataSource.clear();
    if (isClosed) return;
    emit(CartInitial());
  }

  /// Mirrors an explicit local change of [delta] units of [line] to the
  /// Sales Basket, one Add/Delete call per unit. Local and basket changes are
  /// not atomic: when a call fails, the units the basket did not take are
  /// undone locally and [CartFailure] is emitted, as for a failed save.
  Future<void> _sendToBasket(CartItem line, int delta) async {
    if (delta == 0 || !_basket.isSignedIn) return;
    final session = _session;
    final productId = line.productId;
    _changedSinceFetch.add(productId);
    _callsInFlight.update(productId, (calls) => calls + 1, ifAbsent: () => 1);

    var sent = 0;
    Failure? failure;
    while (sent < delta.abs()) {
      final result =
          delta > 0
              ? await _basket.addToSalesBasket(productId)
              : await _basket.removeFromSalesBasket(productId);
      failure = result.fold<Failure?>((failure) => failure, (_) => null);
      if (failure != null) break;
      sent++;
    }

    if (isClosed || session != _session) return;
    final calls = (_callsInFlight[productId] ?? 1) - 1;
    if (calls > 0) {
      _callsInFlight[productId] = calls;
    } else {
      _callsInFlight.remove(productId);
    }
    _changedSinceFetch.add(productId);
    if (failure == null) return;

    final unsent = delta.sign * (delta.abs() - sent);
    await _adjustLine(line, -unsent);
    if (isClosed) return;
    emit(CartFailure(failure));
  }

  Future<void> _adjustLine(CartItem line, int delta) async {
    final index = _cartItems.indexWhere((item) => item.barcode == line.barcode);
    if (index == -1) {
      if (delta > 0) _cartItems.add(line.copyWith(quantity: delta));
    } else {
      final quantity = _cartItems[index].quantity + delta;
      if (quantity > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      } else {
        _cartItems.removeAt(index);
      }
    }
    await _dataSource.saveItems(_cartItems);
  }

  /// Reads the customer's Sales Basket and rewrites the local cart from it.
  /// Never sends Add or Delete. The local cart stays as it is when the basket
  /// cannot be read.
  Future<void> syncWithServer() {
    if (!_basket.isSignedIn) return Future.value();
    return _sync ??= _refreshFromBasket().whenComplete(() => _sync = null);
  }

  Future<void> _refreshFromBasket() async {
    await _loaded;
    final session = _session;
    _changedSinceFetch.clear();
    final result = await _basket.getSalesBasket();
    if (isClosed || session != _session) return;
    final basket = result.fold<List<SalesBasket>?>((failure) {
      emit(CartSyncFailure(failure));
      return null;
    }, (basket) => basket);
    if (basket == null) return;

    final rowsByProduct = <int, List<SalesBasket>>{};
    for (final row in basket) {
      final productId = row.productID;
      if (productId == null || (row.salesQuantity ?? 0) <= 0) continue;
      rowsByProduct.putIfAbsent(productId, () => []).add(row);
    }

    // The basket has no unit names or discounted prices, so each product's
    // current details come from the product endpoint.
    bool needsDetails(int productId, List<SalesBasket> rows) =>
        !_detailsLoaded.contains(productId) ||
        !_cartItems.any((line) => line.productId == productId) ||
        rows.any(
          (row) =>
              (row.barCode?.isNotEmpty ?? false) &&
              _lineWithBarcode(_cartItems, row.barCode) == null,
        );
    final productIds = [
      for (final entry in rowsByProduct.entries)
        if (needsDetails(entry.key, entry.value)) entry.key,
    ];
    final details = await Future.wait([
      for (final productId in productIds) _productDetails(productId),
    ]);
    if (isClosed || session != _session) return;
    final detailsByProduct = {
      for (var i = 0; i < productIds.length; i++) productIds[i]: details[i],
    };
    _detailsLoaded.addAll([
      for (final entry in detailsByProduct.entries)
        if (entry.value != null) entry.key,
    ]);

    final keepLocal = {..._changedSinceFetch, ..._callsInFlight.keys};
    final refreshed = <CartItem>[];
    final placed = <int>{};
    for (final item in _cartItems) {
      final productId = item.productId;
      if (keepLocal.contains(productId)) {
        refreshed.add(item);
      } else if (placed.add(productId) &&
          rowsByProduct.containsKey(productId)) {
        refreshed.addAll(
          _linesFor(
            rowsByProduct[productId]!,
            detailsByProduct[productId],
            _cartItems.where((line) => line.productId == productId).toList(),
          ),
        );
      }
    }
    for (final entry in rowsByProduct.entries) {
      if (keepLocal.contains(entry.key) || placed.contains(entry.key)) continue;
      refreshed.addAll(_linesFor(entry.value, detailsByProduct[entry.key], []));
    }

    // Unchanged lines keep their instances; an unchanged cart is not
    // rewritten or re-emitted.
    for (var i = 0; i < refreshed.length; i++) {
      final current = _lineWithBarcode(_cartItems, refreshed[i].barcode);
      if (current != null &&
          mapEquals(current.toJson(), refreshed[i].toJson())) {
        refreshed[i] = current;
      }
    }
    if (listEquals(refreshed, _cartItems)) return;

    final saved = await _dataSource.saveItems(refreshed);
    if (isClosed || session != _session) return;
    saved.fold((failure) => emit(CartFailure(failure)), (_) {
      _cartItems
        ..clear()
        ..addAll(refreshed);
      emit(CartSyncSuccess());
    });
  }

  Future<ProductDetailsModel?> _productDetails(int productId) async {
    final result = await _products.getProductDetails(productId: productId);
    return result.fold(
      (_) => null,
      (products) => products.isEmpty ? null : products.first,
    );
  }

  /// The local lines of one product as the basket now has it. The basket
  /// holds one quantity per product: a split across sales units is kept only
  /// while its total still matches; otherwise the quantity goes on the unit
  /// the basket recorded.
  List<CartItem> _linesFor(
    List<SalesBasket> rows,
    ProductDetailsModel? product,
    List<CartItem> localLines,
  ) {
    final quantity = rows.fold<int>(
      0,
      (sum, row) => sum + (row.salesQuantity ?? 0),
    );
    final localTotal = localLines.fold<int>(
      0,
      (sum, line) => sum + line.quantity,
    );

    final List<({String barcode, int quantity, CartItem? local})> targets;
    if (localLines.isNotEmpty && localTotal == quantity) {
      targets = [
        for (final line in localLines)
          (barcode: line.barcode, quantity: line.quantity, local: line),
      ];
    } else {
      final barcodes = rows.map((row) => row.barCode ?? '').toSet();
      if (rows.length > 1 && barcodes.length == rows.length) {
        targets = [
          for (final row in rows)
            (
              barcode: row.barCode!,
              quantity: row.salesQuantity ?? 0,
              local: _lineWithBarcode(localLines, row.barCode),
            ),
        ];
      } else {
        final barcode = rows.first.barCode;
        final local =
            _lineWithBarcode(localLines, barcode) ??
            (localLines.isEmpty ? null : localLines.first);
        targets = [
          (
            barcode:
                (barcode == null || barcode.isEmpty)
                    ? (local?.barcode ?? '')
                    : barcode,
            quantity: quantity,
            local: local,
          ),
        ];
      }
    }

    final row = rows.first;
    final units = product?.productUnitImages ?? const <UnitsModel>[];
    return [
      for (final target in targets)
        if (target.quantity > 0)
          if (_fromDetails(
                product,
                units,
                row,
                target.barcode,
                fallbackToBaseUnit: targets.length == 1,
              )
              case final item?)
            item.copyWith(quantity: target.quantity)
          else if (target.local case final local?)
            local.copyWith(
              quantity: target.quantity,
              stockQuantity: row.stockQuantity ?? local.stockQuantity,
              image:
                  (row.productImage?.isNotEmpty ?? false)
                      ? row.productImage
                      : local.image,
            ),
    ];
  }

  /// Builds a cart line the way the product page does.
  CartItem? _fromDetails(
    ProductDetailsModel? product,
    List<UnitsModel> units,
    SalesBasket row,
    String barcode, {
    required bool fallbackToBaseUnit,
  }) {
    if (product == null || units.isEmpty) return null;
    UnitsModel? unit;
    for (final candidate in units) {
      if (candidate.barcode == barcode) {
        unit = candidate;
        break;
      }
    }
    if (fallbackToBaseUnit) {
      unit ??= ProductUnits.baseUnit(units) ?? units.first;
    }
    if (unit == null) return null;
    return ProductUnits.cartItemFor(
      unit: unit,
      productId: row.productID!,
      productArName: '${product.productArName}',
      productEnName: '${product.productEnName}',
      image: product.productcImage.toString(),
    );
  }

  static CartItem? _lineWithBarcode(List<CartItem> lines, String? barcode) {
    for (final line in lines) {
      if (line.barcode == barcode) return line;
    }
    return null;
  }
}
