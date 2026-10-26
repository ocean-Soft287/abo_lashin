import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/cart/data/model/cart_item_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartAddItemSuccess extends CartState {}

class GetCartItemSuccess extends CartState {
  List<CartItem> items;
  GetCartItemSuccess({required this.items});
}

class CartRemoveItemSuccess extends CartState {}

class CartFailure extends CartState {
  final Failure? failure;

  CartFailure([this.failure]);
}

class CartSyncSuccess extends CartState {}

/// The Sales Basket could not be reached; the local cart is kept as it is.
class CartSyncFailure extends CartState {
  final Failure failure;

  CartSyncFailure(this.failure);
}
