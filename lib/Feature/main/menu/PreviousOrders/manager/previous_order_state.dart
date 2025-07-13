
abstract class PreviousOrderState{}
class InitializePreviousOrder extends PreviousOrderState{}

class GetPreviousOrderLoading extends PreviousOrderState{}
class GetPreviousOrderSuccess extends PreviousOrderState {

}
class GetPreviousOrderError extends PreviousOrderState{}

class GetPreviousOrderItemsLoading extends PreviousOrderState{}
class GetPreviousOrderItemsSuccess extends PreviousOrderState{}
class GetPreviousOrderItemsError extends PreviousOrderState{}


class OrderTrackingLoading extends PreviousOrderState{}


class OrderTrackingSuccess extends PreviousOrderState {

  OrderTrackingSuccess();
}


class OrderTrackingError extends PreviousOrderState {
  final String errorMessage;
  OrderTrackingError({required this.errorMessage});
}