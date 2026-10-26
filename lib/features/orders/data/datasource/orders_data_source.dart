import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/network/data_source/encrypted_data_source.dart';
import 'package:abolashin/core/network/either.dart';
import 'package:abolashin/core/network/end_point.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:abolashin/features/orders/data/model/previous_order_details_model.dart';
import 'package:abolashin/features/orders/data/model/previous_order_model.dart';

class OrdersDataSource {
  final EncryptedDataSource _api;
  final SessionManager _session;

  const OrdersDataSource(this._api, this._session);

  bool get canViewOrders =>
      _session.isAuthenticated && _session.customerPhone.isNotEmpty;

  Future<Either<Failure, List<PreviousOrdersModel>>> getPreviousOrders() async {
    if (!canViewOrders) return const Right([]);
    return _api.getList(
      Endpoints.orders(_session.customerPhone),
      fromJson: PreviousOrdersModel.fromJson,
    );
  }

  Future<Either<Failure, List<PreviousOrdersModel>>> getCurrentOrders() async {
    if (!canViewOrders) return const Right([]);
    return _api.getList(
      Endpoints.currentOrders(_session.customerPhone),
      fromJson: PreviousOrdersModel.fromJson,
    );
  }

  Future<Either<Failure, List<PreviousOrderDetailsModel>>> getOrderProducts({
    required int orderId,
  }) async {
    if (!canViewOrders) return const Right([]);
    return _api.getList(
      Endpoints.orderProducts(orderId),
      queryParameters: {'CustomerPhone': _session.customerPhone},
      fromJson: PreviousOrderDetailsModel.fromJson,
    );
  }
}
