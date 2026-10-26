import 'dart:io';

import 'package:dio/dio.dart';

import '../connectivity/connectivity_service.dart';

class ReachabilityInterceptor extends Interceptor {
  final ConnectivityService _connectivity;

  const ReachabilityInterceptor(this._connectivity);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _connectivity.reportRequestResult(reachedServer: true);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _connectivity.reportRequestResult(reachedServer: true);
    } else if (err.type == DioExceptionType.connectionError ||
        err.error is SocketException) {
      _connectivity.reportRequestResult(reachedServer: false);
    }
    handler.next(err);
  }
}
