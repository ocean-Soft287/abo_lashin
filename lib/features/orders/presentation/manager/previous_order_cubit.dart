import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/features/orders/data/datasource/orders_data_source.dart';
import 'package:abolashin/features/orders/data/model/previous_order_details_model.dart';
import 'package:abolashin/features/orders/data/model/previous_order_model.dart';
import 'package:abolashin/features/orders/presentation/manager/previous_order_state.dart';

class PreviousOrderCubit extends Cubit<PreviousOrderState> {
  PreviousOrderCubit({OrdersDataSource? dataSource})
    : _dataSource = dataSource ?? getIt<OrdersDataSource>(),
      super(InitializePreviousOrder());

  final OrdersDataSource _dataSource;

  final StreamController<List<PreviousOrdersModel>> _previousOrdersController =
      StreamController<List<PreviousOrdersModel>>.broadcast();
  Stream<List<PreviousOrdersModel>> get previousOrdersStream =>
      _previousOrdersController.stream;

  final StreamController<List<PreviousOrdersModel>>
  _orderTrackingDetailsController =
      StreamController<List<PreviousOrdersModel>>.broadcast();
  Stream<List<PreviousOrdersModel>> get orderTrackingDetailsStream =>
      _orderTrackingDetailsController.stream;

  List<PreviousOrdersModel> previousOrderList = [];
  List<PreviousOrderDetailsModel> previousOrderDetailsList = [];
  List<PreviousOrdersModel> orderTrackingDetails = [];

  Timer? _timer;
  bool _refreshing = false;
  static const Duration _trackingInterval = Duration(seconds: 15);
  bool previousOrderLoading = true;

  bool get canViewOrders => _dataSource.canViewOrders;

  Future<void> getPreviousOrders() async {
    if (isClosed) return;
    emit(GetPreviousOrderLoading());
    final result = await _dataSource.getPreviousOrders();
    if (isClosed) return;
    result.fold((failure) => emit(GetPreviousOrderError(failure)), (newList) {
      previousOrderList = newList;
      previousOrderLoading = false;
      if (!_previousOrdersController.isClosed) {
        _previousOrdersController.add(previousOrderList);
      }
      emit(GetPreviousOrderSuccess());
    });
  }

  Future<void> getPreviousOrderDetails({required int orderId}) async {
    if (isClosed) return;
    emit(GetPreviousOrderItemsLoading());
    final result = await _dataSource.getOrderProducts(orderId: orderId);
    if (isClosed) return;
    result.fold((failure) => emit(GetPreviousOrderItemsError(failure)), (
      items,
    ) {
      previousOrderDetailsList = items;
      emit(GetPreviousOrderItemsSuccess());
    });
  }

  Future<void> getOrderTrackingDetails() async {
    if (isClosed) return;
    emit(OrderTrackingLoading());
    final result = await _dataSource.getCurrentOrders();
    if (isClosed) return;
    result.fold((failure) => emit(OrderTrackingError(failure)), (orders) {
      orderTrackingDetails = orders;
      if (!_orderTrackingDetailsController.isClosed) {
        _orderTrackingDetailsController.add(orderTrackingDetails);
      }
      emit(OrderTrackingSuccess());
    });
  }

  void startOrderTrackingRealtime() {
    if (isClosed) return;

    getOrderTrackingDetails();
    if (!_dataSource.canViewOrders) return;
    _timer?.cancel();
    _timer = Timer.periodic(_trackingInterval, (timer) async {
      if (isClosed) {
        timer.cancel();
        return;
      }
      if (_refreshing) return;
      _refreshing = true;
      try {
        await Future.wait([getOrderTrackingDetails(), getPreviousOrders()]);
      } finally {
        _refreshing = false;
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _previousOrdersController.close();
    _orderTrackingDetailsController.close();
    return super.close();
  }
}
