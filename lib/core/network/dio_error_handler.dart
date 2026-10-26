import 'dart:io';

import 'package:dio/dio.dart';

import 'failure.dart';

class DioErrorHandler {
  DioErrorHandler._();

  static Failure handle(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;

    final responseData = response?.data;

    final message = _extractMessage(responseData);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return RequestTimeOutFailure(
          message: 'Connection timeout. Please try again.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.sendTimeout:
        return SendTimeOutFailure(
          message: 'Request timeout. Please try again.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.receiveTimeout:
        return ReceiveTimeOutFailure(
          message: 'Server response timeout. Please try again.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.connectionError:
        return ConnectionFailure(
          message: 'Unable to connect to the server.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badCertificate:
        return ConnectionFailure(
          message: 'Secure connection failed.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.cancel:
        return UnknownFailure(
          message: 'Request was cancelled.',
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(
          statusCode: statusCode,
          message: message,
          data: responseData,
          stackTrace: error.stackTrace,
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ConnectionFailure(
            message: 'No internet connection.',
            statusCode: statusCode,
            data: responseData,
            stackTrace: error.stackTrace,
          );
        }

        return UnknownFailure(
          message: message,
          statusCode: statusCode,
          data: responseData,
          stackTrace: error.stackTrace,
        );
    }
  }

  static Failure _handleStatusCode({
    required int? statusCode,
    required String message,
    required dynamic data,
    required StackTrace? stackTrace,
  }) {
    switch (statusCode) {
      case 401:
        return UnauthorizedFailure(
          message:
              message.isEmpty
                  ? 'Session expired. Please login again.'
                  : message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );

      case 402:
        return PaymentFailure(
          message: message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );

      case 404:
        return NotFoundFailure(
          message: message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );

      case 400:
      case 409:
      case 422:
        return ValidationFailure(
          message: message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );

      case 413:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );

      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return ValidationFailure(
            message: message,
            statusCode: statusCode,
            data: data,
            stackTrace: stackTrace,
          );
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerFailure(
            message: message,
            statusCode: statusCode,
            data: data,
            stackTrace: stackTrace,
          );
        }

        return UnknownFailure(
          message: message,
          statusCode: statusCode,
          data: data,
          stackTrace: stackTrace,
        );
    }
  }

  static String _extractMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is Map) {
      final candidates = [
        data['message'],
        data['Message'],
        data['error'],
        data['Error'],
        data['detail'],
        data['Detail'],
        data['title'],
        data['Title'],
      ];

      for (final value in candidates) {
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }

      final errors = data['errors'];

      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;

        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }

        if (firstValue != null) {
          return firstValue.toString();
        }
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
