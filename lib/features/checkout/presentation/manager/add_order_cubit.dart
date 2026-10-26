import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/helpers/logger.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/addresses/data/datasource/addresses_data_source.dart';
import 'package:abolashin/features/addresses/data/model/all_address_model.dart';
import 'package:abolashin/features/checkout/data/datasource/checkout_data_source.dart';
import 'package:abolashin/features/checkout/data/model/add_item.dart';
import 'package:abolashin/features/checkout/data/model/order_summary_model.dart';
import 'package:abolashin/features/checkout/data/model/sales_basket.dart';
import 'package:abolashin/features/checkout/presentation/manager/add_order_state.dart';

class AddOrderCubit extends Cubit<AddOrderState> {
  AddOrderCubit({
    CheckoutDataSource? dataSource,
    AddressesDataSource? addresses,
  }) : _dataSource = dataSource ?? getIt<CheckoutDataSource>(),
       _addresses = addresses ?? getIt<AddressesDataSource>(),
       super(InitializeAddOrder());

  final CheckoutDataSource _dataSource;
  final AddressesDataSource _addresses;

  int _sessionGeneration = 0;

  OrderSummryModel? orderSummryModel;

  static List<Map<String, dynamic>> buildOrderItems(dynamic listItem) =>
      CheckoutDataSource.buildOrderItems(listItem);

  Future<void> loadForSession() async {
    _sessionGeneration++;
    allAddressList = [];
    selectAddress = 0;
    addressesFailure = null;
    addressesLoading = false;
    salesBasketList = [];
    items.clear();
    orderSummryModel = null;

    if (!_dataSource.isSignedIn) {
      if (!isClosed) emit(InitializeAddOrder());
      return;
    }

    final address = getAllAddress();
    final basket = getCustomerSalesBasket();
    getQuitity();
    await Future.wait([address, basket]);
  }

  Future<void> addOrder({
    required String customName,
    required double total,
    required dynamic listItem,
    required dynamic districtName,
    required dynamic regionName,
    required String email,
    required String customerAddress,
    required num addition,
    required num discount,
    required String discountCode,
    required String notes,
  }) async {
    if (state is AddOrderLoading) return;
    emit(AddOrderLoading());

    final payload = _dataSource.buildOrderPayload(
      customName: customName,
      total: total,
      listItem: listItem,
      districtName: districtName,
      regionName: regionName,
      customerAddress: customerAddress,
      addition: addition,
      discount: discount,
      notes: notes,
    );
    final filteredOrderList = payload["OrderItems"] as List;

    final result = await _dataSource.placeOrder(payload);
    if (isClosed) return;
    result.fold((failure) => emit(AddOrderError(failure)), (placed) {
      try {
        orderSummryModel = OrderSummryModel.fromJson(placed.payload);
      } catch (error, stackTrace) {
        loggerError(error, stackTrace: stackTrace);
        orderSummryModel = null;
      }
      emit(AddOrderSuccess(orderSummryModel, filteredOrderList, placed.id));
    });
  }

  int pageNumberSalesBasket = 1;
  bool salesBasketLoading = true;
  List<SalesBasket> salesBasketList = [];

  Future<void> getCustomerSalesBasket({bool fromPagination = true}) async {
    if (!fromPagination) emit(GetCustomerSalesBasketLoading());
    final generation = _sessionGeneration;

    final result = await _dataSource.getSalesBasket();
    if (isClosed || generation != _sessionGeneration) return;
    result.fold((failure) => emit(GetCustomerSalesBasketError(failure)), (
      basket,
    ) {
      salesBasketLoading = false;
      pageNumberSalesBasket++;
      salesBasketList = List.of(basket);
      items
        ..clear()
        ..addAll([
          for (final item in salesBasketList)
            CartItem(
              quantity: int.parse(item.salesQuantity.toString()),
              itemId: item.productID.toString(),
              price: double.parse(item.price.toString()),
            ),
        ]);
      emit(GetCustomerSalesBasketSuccess());
    });
  }

  Future<void> addItem({required dynamic productId, dynamic context}) async {
    if (!_dataSource.isSignedIn) return;
    emit(AddItemSalesBasketLoading());
    final result = await _dataSource.addToSalesBasket(productId);
    if (isClosed) return;
    result.fold((failure) => emit(AddItemSalesBasketError(failure)), (_) {
      getQuitity();
      emit(AddItemSalesBasketSuccess());
    });
  }

  Future<void> decreaseItem({required dynamic productId}) async {
    if (!_dataSource.isSignedIn) return;
    emit(DecreaseSalesBasketLoading());
    final result = await _dataSource.removeFromSalesBasket(productId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(DecreaseSalesBasketError(failure)),
      (_) => emit(DecreaseSalesBasketSuccess()),
    );
  }

  List<CartItem> items = [];

  void addItemCart({
    required int quantity,
    required String itemId,
    required double price,
  }) {
    bool itemFound = false;

    for (var item in items) {
      if (item.itemId == itemId) {
        item.quantity += quantity;
        emit(AddItemInCart());
        addItem(productId: item.itemId);
        itemFound = true;
        break;
      }
    }

    if (!itemFound) {
      final newItem = CartItem(
        quantity: quantity,
        itemId: itemId,
        price: price,
      );
      items.add(newItem);
      emit(AddItemInCart());
    }
  }

  void printCart() {
    if (items.isEmpty) return;
    for (final item in items) {
      logger('${item.itemId} x${item.quantity}');
    }
  }

  void subtractItemCart({
    required int quantity,
    required String itemId,
    required int index,
  }) {
    for (var item in items) {
      if (item.itemId == itemId) {
        item.quantity -= quantity;

        if (item.quantity <= 0) {
          items.remove(item);
          if (index >= 0 && index < salesBasketList.length) {
            salesBasketList.removeAt(index);
          }

          emit(RemoveItemFromCart());
          decreaseItem(productId: itemId);
        } else {
          emit(SubtractItemFromCart());
          decreaseItem(productId: itemId);
        }
        return;
      }
    }
  }

  int getQuantity(String itemId) {
    for (var item in items) {
      if (item.itemId == itemId) {
        return item.quantity;
      }
    }
    return 1;
  }

  double totalPrice = 0.0;
  double calculateTotalPrice() {
    totalPrice = 0.0;

    for (var item in items) {
      totalPrice += item.quantity * item.price;
    }

    return totalPrice;
  }

  void getQuitity() {
    if (isClosed) return;
    emit(ChangeQUtityCart());
  }

  List<dynamic> governoratesList = [];

  Future<void> getGovernorates() async {
    emit(GetGovernoratesLoading());
    final result = await _addresses.getGovernorates();
    if (isClosed) return;
    result.fold((failure) => emit(GetGovernoratesError(failure)), (list) {
      governoratesList = list;
      emit(GetGovernoratesSuccess());
    });
  }

  List<AllAddressModel> allAddressList = [];

  bool addressesLoading = false;

  Failure? addressesFailure;

  Future<void> getAllAddress() async {
    final generation = _sessionGeneration;
    addressesLoading = true;
    addressesFailure = null;
    emit(GetGAllAddressLoading());

    final result = await _addresses.getCustomerAddresses();
    if (isClosed || generation != _sessionGeneration) return;
    addressesLoading = false;
    result.fold(
      (failure) {
        addressesFailure = failure;
        emit(GetGAllAddressError(failure));
      },
      (addresses) {
        allAddressList = addresses;
        selectAddress = _restoreSelectedAddress(addresses);
        emit(GetGAllAddressSuccess());
      },
    );
  }

  /// The address the customer chose before when it still exists, otherwise
  /// the first one (an automatic default, not saved as a choice).
  int _restoreSelectedAddress(List<AllAddressModel> addresses) {
    final savedId = _addresses.selectedAddressId;
    if (savedId == null || savedId.isEmpty) return 0;
    final index = addresses.indexWhere((a) => a.addressID == savedId);
    if (index != -1) return index;
    _addresses.saveSelectedAddressId(null);
    return 0;
  }

  int selectAddress = 0;

  /// The delivery address used by the cart and checkout, or null when the
  /// customer has no saved address.
  AllAddressModel? get selectedAddress =>
      (selectAddress >= 0 && selectAddress < allAddressList.length)
          ? allAddressList[selectAddress]
          : null;

  /// The minimum order for [selectedAddress] (its area's `BillValue`): 0 when
  /// none is set, null when the value cannot be read.
  double? get minimumOrderValue {
    final text = selectedAddress?.billValue?.toString().trim() ?? '';
    return text.isEmpty ? 0 : double.tryParse(text);
  }

  /// Whether checkout can use [selectedAddress]: the list has finished
  /// loading and the selection is one of its addresses, with an address
  /// line (what the cart shows and the order sends).
  bool get hasValidAddress =>
      !addressesLoading &&
      (selectedAddress?.address?.trim().isNotEmpty ?? false);

  void changeSelectedAddress(int index) {
    selectAddress = index;
    final addressId = selectedAddress?.addressID ?? '';
    if (addressId.isNotEmpty) _addresses.saveSelectedAddressId(addressId);
    emit(ChangeSelectedAddress());
  }

  Future<Either<Failure, bool>> verifyCustomerIsActive() =>
      _dataSource.isCustomerActive();

  Future<String> checkCustomerIsActive() async {
    final result = await verifyCustomerIsActive();
    return result.fold(
      (_) => "False",
      (isActive) => isActive ? "True" : "False",
    );
  }
}
