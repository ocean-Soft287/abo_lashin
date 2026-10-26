import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/checkout/data/model/order_summary_model.dart';

abstract class AddOrderState {}

class InitializeAddOrder extends AddOrderState {}

class ChangeArea extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {
  OrderSummryModel? orderSummryModel;
  List? listItemName;
  String id;
  AddOrderSuccess(this.orderSummryModel, this.listItemName, this.id);
}

class AddOrderError extends AddOrderState {
  final Failure? failure;
  AddOrderError([this.failure]);

  String get error => failure?.messageKey ?? 'order_error';
}

class GetCustomerSalesBasketLoading extends AddOrderState {}

class GetCustomerSalesBasketSuccess extends AddOrderState {}

class GetCustomerSalesBasketError extends AddOrderState {
  final Failure? failure;
  GetCustomerSalesBasketError([this.failure]);
}

class AddItemSalesBasketLoading extends AddOrderState {}

class AddItemSalesBasketSuccess extends AddOrderState {}

class AddItemSalesBasketError extends AddOrderState {
  final Failure? failure;
  AddItemSalesBasketError([this.failure]);
}

class DecreaseSalesBasketLoading extends AddOrderState {}

class DecreaseSalesBasketSuccess extends AddOrderState {}

class DecreaseSalesBasketError extends AddOrderState {
  final Failure? failure;
  DecreaseSalesBasketError([this.failure]);
}

class AddItemInCart extends AddOrderState {}

class SubtractItemFromCart extends AddOrderState {}

class RemoveItemFromCart extends AddOrderState {}

class ChangeQUtityCart extends AddOrderState {}

class GetGovernoratesLoading extends AddOrderState {}

class GetGovernoratesSuccess extends AddOrderState {}

class GetGovernoratesError extends AddOrderState {
  final Failure? failure;
  GetGovernoratesError([this.failure]);
}

class GetGAllAddressLoading extends AddOrderState {}

class GetGAllAddressSuccess extends AddOrderState {}

class GetGAllAddressError extends AddOrderState {
  final Failure? failure;
  GetGAllAddressError([this.failure]);
}

class ChangeSelectedAddress extends AddOrderState {}
