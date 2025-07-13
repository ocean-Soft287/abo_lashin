  import 'package:abolashin/Feature/main/cart/screen/model/cart_item_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartAddItemSuccess extends CartState {


}


  class GetCartItemSuccess extends CartState {
  List<CartItem>items;
    GetCartItemSuccess({required this.items});

  }
  class CartRemoveItemSuccess extends CartState {


  }

class CartFailure extends CartState {
  CartFailure(this.error);
  final String error;
}