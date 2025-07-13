import '../model/order_summry_model.dart';

abstract class AddOrderState{}
class InitializeAddOrder extends AddOrderState{}




class ChangeArea extends AddOrderState{}


class AddOrderLoading extends AddOrderState{}
class AddOrderSuccess extends AddOrderState{

  OrderSummryModel? orderSummryModel;
  List? listItemName;
  String id;
  AddOrderSuccess(this.orderSummryModel,this.listItemName,this.id);
}
class AddOrderError extends AddOrderState{
  final String error;
  AddOrderError(this.error);
}

////

class GetCustomerSalesBasketLoading extends AddOrderState{}
class GetCustomerSalesBasketSuccess extends AddOrderState{}
class GetCustomerSalesBasketError extends AddOrderState{}


class AddItemSalesBasketLoading extends AddOrderState{}
class AddItemSalesBasketSuccess extends AddOrderState{}
class AddItemSalesBasketError extends AddOrderState{}


class DecreaseSalesBasketLoading extends AddOrderState{}
class DecreaseSalesBasketSuccess extends AddOrderState{}
class DecreaseSalesBasketError extends AddOrderState{}

class AddItemInCart extends AddOrderState{}
class SubtractItemFromCart extends AddOrderState{}
class RemoveItemFromCart extends AddOrderState{}

class ChangeQUtityCart extends AddOrderState{}


class GetGovernoratesLoading extends AddOrderState{}
class GetGovernoratesSuccess extends AddOrderState{}
class GetGovernoratesError extends AddOrderState{}


class GetGAllAddressLoading extends AddOrderState{}
class GetGAllAddressSuccess extends AddOrderState{}
class GetGAllAddressError extends AddOrderState{}

class ChangeSelectedAddress extends AddOrderState{}





class GetDiscountLoading extends AddOrderState{}
class GetDiscountSuccess extends AddOrderState{}
class GetDiscountError extends AddOrderState{
  var error;
  GetDiscountError({this.error});
}




