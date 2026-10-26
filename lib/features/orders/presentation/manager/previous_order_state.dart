import 'package:abolashin/core/network/failure.dart';

abstract class PreviousOrderState {}

class InitializePreviousOrder extends PreviousOrderState {}

class GetPreviousOrderLoading extends PreviousOrderState {}

class GetPreviousOrderSuccess extends PreviousOrderState {}

class GetPreviousOrderError extends PreviousOrderState {
  final Failure? failure;

  GetPreviousOrderError([this.failure]);
}

class GetPreviousOrderItemsLoading extends PreviousOrderState {}

class GetPreviousOrderItemsSuccess extends PreviousOrderState {}

class GetPreviousOrderItemsError extends PreviousOrderState {
  final Failure? failure;

  GetPreviousOrderItemsError([this.failure]);
}

class OrderTrackingLoading extends PreviousOrderState {}

class OrderTrackingSuccess extends PreviousOrderState {
  OrderTrackingSuccess();
}

class OrderTrackingError extends PreviousOrderState {
  final Failure? failure;

  OrderTrackingError([this.failure]);

  String get errorMessage => failure?.messageKey ?? 'error_unknown';
}
