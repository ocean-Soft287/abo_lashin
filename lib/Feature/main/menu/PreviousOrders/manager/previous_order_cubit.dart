import 'dart:async';
import 'dart:convert';
import 'package:abolashin/Feature/main/menu/PreviousOrders/manager/previous_order_state.dart';
import 'package:abolashin/core/network/remote/end_point.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/remote/diohelper.dart';
import '../../../../../core/network/remote/encrupt.dart';
import '../model/previous_order_details_model.dart';
import '../model/previous_order_model.dart';

class PreviousOrderCubit extends Cubit<PreviousOrderState> {
  PreviousOrderCubit() : super(InitializePreviousOrder());

  final StreamController<List<PreviousOrdersModel>> _previousOrdersController =
  StreamController<List<PreviousOrdersModel>>.broadcast();
  Stream<List<PreviousOrdersModel>> get previousOrdersStream =>
      _previousOrdersController.stream;

  final StreamController<List<PreviousOrdersModel>> _orderTrackingDetailsController =
  StreamController<List<PreviousOrdersModel>>.broadcast();
  Stream<List<PreviousOrdersModel>> get orderTrackingDetailsStream =>
      _orderTrackingDetailsController.stream;

  List<PreviousOrdersModel> previousOrderList = [];
  List<PreviousOrderDetailsModel> previousOrderDetailsList = [];
  List<PreviousOrdersModel> orderTrackingDetails = [];

  Timer? _timer;
  bool previousOrderLoading = true;

  Future<String> asyncDecrypt(String data) async {
    return await Future(() => decrypt(data, privateKey, publicKey));
  }

  void getPreviousOrders() async {
    if (!isClosed) emit(GetPreviousOrderLoading());
    final start = DateTime.now();

    try {
      final response = await DioHelper.getData(url: Endpoints.previousOrdersByPhone);
      final decryptedText = await asyncDecrypt(response.data);
      final jsonList = jsonDecode(decryptedText);
      final newList = (jsonList as List)
          .map((json) => PreviousOrdersModel.fromJson(json))
          .toList();

      final hasStatusChanged = previousOrderList.length != newList.length;

      if (hasStatusChanged) {
        previousOrderList = newList;
        previousOrderLoading = false;
        _previousOrdersController.sink.add(previousOrderList);
        if (!isClosed) emit(GetPreviousOrderSuccess());
      }

      final end = DateTime.now();
      print("⏱️ Orders loaded in ${end.difference(start).inMilliseconds}ms");
    } catch (error) {
      if (!isClosed) emit(GetPreviousOrderError());
    }
  }

  void getPreviousOrderDetails({required int orderId}) async {
    if (!isClosed) emit(GetPreviousOrderItemsLoading());

    try {
      final response = await DioHelper.getData(
        url: Endpoints.previousOrdersItem(itemId: orderId),
      );
      final decryptedText = await asyncDecrypt(response.data);
      final jsonList = jsonDecode(decryptedText);
      previousOrderDetailsList = (jsonList as List)
          .map((json) => PreviousOrderDetailsModel.fromJson(json))
          .toList();

      if (!isClosed) emit(GetPreviousOrderItemsSuccess());
    } catch (error) {
      if (!isClosed) emit(GetPreviousOrderItemsError());
    }
  }

  void getOrderTrackingDetails() async {
    if (!isClosed) emit(OrderTrackingLoading());

    try {
      final response = await DioHelper.getData(url: Endpoints.previousTrackingOrdersByPhone);
      final decryptedText = await asyncDecrypt(response.data);
      final jsonList = jsonDecode(decryptedText);
      orderTrackingDetails = (jsonList as List)
          .map((json) => PreviousOrdersModel.fromJson(json))
          .toList();

      _orderTrackingDetailsController.sink.add(orderTrackingDetails);
      if (!isClosed) emit(OrderTrackingSuccess());
    } catch (error) {
      if (!isClosed) emit(OrderTrackingError(errorMessage: error.toString()));
    }
  }

  void startOrderTrackingRealtime() {
    if (isClosed) return;

    getOrderTrackingDetails();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (isClosed) {
        timer.cancel();
      } else {
        getOrderTrackingDetails();
        getPreviousOrders();
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
