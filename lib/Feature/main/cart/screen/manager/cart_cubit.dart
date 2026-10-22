import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constans/constants.dart';
import '../../../../../core/network/local/hive_manger.dart';
import '../../../../../core/network/remote/diohelper.dart';
import '../../../../../core/network/remote/encrupt.dart';
import '../../../product_details/model/product_details_model.dart';
import '../model/cart_item_model.dart';
import 'chat_state.dart';

const String cartBox = 'cartBox';
const String cartKey = 'cartItems';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _loadCartItems();
  }

  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  Future<void> _loadCartItems() async {
    emit(CartLoading());
    try {
      final loadedList = await HiveCrudManager.readList(cartBox, cartKey);
print(loadedList);
      if (loadedList != null) {
        _cartItems.clear();
        // تحويل كل عنصر من Map إلى CartItem باستخدام fromJson
        _cartItems.addAll(loadedList.map((e) => CartItem.fromJson(Map<String, dynamic>.from(e))));

      }

      emit(CartAddItemSuccess());
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }


  // بيجيب أحدث سعر ومخزون لكل منتج في السلة من السيرفر
  Future<void> refreshCartPrices() async {
    if (_cartItems.isEmpty) return;
    emit(CartLoading());

    final productIds = _cartItems.map((e) => e.productId).toSet();
    final results = await Future.wait(productIds.map(_fetchProduct));
    final products = {
      for (final p in results)
        if (p != null) p.productID!.toInt(): p,
    };

    for (var i = 0; i < _cartItems.length; i++) {
      final item = _cartItems[i];
      final product = products[item.productId];
      if (product == null) continue; // لو الطلب فشل نسيب السعر القديم

      final unit = product.productUnitImages
          ?.where((u) => u.barcode == item.barcode)
          .firstOrNull;

      if (unit != null) {
        _cartItems[i] = item.copyWith(
          priceBeforeDiscount: unit.price,
          priceAfterDiscount: unit.priceAfterDiscount,
          stockQuantity: unit.stockQty,
          customerQuantity: unit.customerQuantity,
        );
      } else if (product.barCode == item.barcode) {
        _cartItems[i] = item.copyWith(
          priceBeforeDiscount: product.price?.toDouble(),
          priceAfterDiscount: product.priceAfterDiscount?.toDouble(),
          stockQuantity: product.stockQuantity,
          customerQuantity: product.customerQuantity,
        );
      }
    }

    await HiveCrudManager.saveList(
      cartBox,
      cartKey,
      _cartItems.map((e) => e.toJson()).toList(),
    );
    emit(CartAddItemSuccess());
  }

  Future<ProductDetailsModel?> _fetchProduct(int productId) async {
    try {
      final value = await DioHelper.getData(
        url:
            '/api/Product/GetProductById?ProductId=$productId&CustomerPhone=$customerPhone',
      );
      if (value.statusCode != 200) return null;
      final decryptedText = decrypt(value.data, privateKey, publicKey);
      final List<dynamic> jsonList = jsonDecode(decryptedText);
      if (jsonList.isEmpty) return null;
      return ProductDetailsModel.fromJson(jsonList.first);
    } catch (e) {
      return null;
    }
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
      orElse: () => CartItem(
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
    try {
      final index = _cartItems.indexWhere((item) => item.barcode == newItem.barcode);

      if (index != -1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity:_cartItems[index].quantity + 1,

          customerQuantity: _cartItems[index].customerQuantity
        );
        print(_cartItems[index].customerQuantity ,);
      } else {
        _cartItems.add(newItem.copyWith(quantity: 1, ));
      }

      await HiveCrudManager.saveList(cartBox, cartKey, _cartItems.map((e) => e.toJson()).toList());
      emit(CartAddItemSuccess());
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> removeItem(String barcode) async {
    emit(CartLoading());
    try {
      final index = _cartItems.indexWhere((item) => item.barcode == barcode);
      if (index != -1) {
        if (_cartItems[index].quantity > 1) {
          print(cartItems[index].quantity);
          print(cartItems[index].customerQuantity);

          _cartItems[index] = _cartItems[index].copyWith(
            quantity: _cartItems[index].quantity - 1,
          );
        } else {
          _cartItems.removeAt(index);
        }

        // حفظ كـ JSON
        await HiveCrudManager.saveList(
          cartBox,
          cartKey,
          _cartItems.map((e) => e.toJson()).toList(),
        );

        emit(CartRemoveItemSuccess());
      }
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }


  Future<void> clearCart() async {
    _cartItems.clear();
    await HiveCrudManager.deleteList(cartBox, cartKey);
    emit(CartInitial());
  }
}
