import 'dart:io';

import 'package:abolashin/core/connectivity/connection_status.dart';
import 'package:abolashin/core/connectivity/connectivity_service.dart';
import 'package:abolashin/core/network/dio_error_handler.dart';
import 'package:abolashin/core/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityService reachability', () {
    final service = ConnectivityService.instance;

    test('server unreachable is reported once, then recovers', () async {
      final events = <ConnectionStatus>[];
      final sub = service.stream.listen(events.add);

      service.reportRequestResult(reachedServer: false);
      service.reportRequestResult(reachedServer: false);
      expect(service.currentStatus, ConnectionStatus.serverUnreachable);
      expect(service.isOnline, isFalse);

      service.reportRequestResult(reachedServer: true);
      await Future<void>.delayed(Duration.zero);
      expect(service.isOnline, isTrue);
      expect(events, [
        ConnectionStatus.serverUnreachable,
        ConnectionStatus.connected,
      ]);
      await sub.cancel();
    });
  });

  group('Failure message keys', () {
    Failure handle(DioException e) => DioErrorHandler.handle(e);
    final options = RequestOptions(path: '/x');

    test('distinguishes connectivity, timeout, server and auth', () {
      expect(
        handle(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ).messageKey,
        'error_network',
      );
      expect(
        handle(
          DioException(
            requestOptions: options,
            error: const SocketException('down'),
          ),
        ).messageKey,
        'error_network',
      );
      expect(
        handle(
          DioException(
            requestOptions: options,
            type: DioExceptionType.receiveTimeout,
          ),
        ).messageKey,
        'error_timeout',
      );
      Failure status(int code) => handle(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: options, statusCode: code),
        ),
      );
      expect(status(500).messageKey, 'error_server');
      expect(status(401).messageKey, 'error_unauthorized');
      expect(status(404).messageKey, 'error_not_found');
      expect(status(400).messageKey, 'error_request_rejected');
    });
  });
}
