enum FailureType {
  auth,
  network,
  server,
  validation,
  cache,
  payment,
  parsing,
  sync,
  unknown,
}

abstract class Failure implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final StackTrace? stackTrace;
  final String? code;
  final FailureType type;

  const Failure({
    required this.message,
    this.statusCode,
    this.data,
    this.stackTrace,
    this.code,
    required this.type,
  });

  String get displayMessage =>
      message.trim().isEmpty
          ? 'Something went wrong. Please try again.'
          : message;

  String get messageKey => switch (this) {
    RequestTimeOutFailure() ||
    SendTimeOutFailure() ||
    ReceiveTimeOutFailure() => 'error_timeout',
    NotFoundFailure() => 'error_not_found',
    _ => _typeMessageKey,
  };

  String get _typeMessageKey => switch (type) {
    FailureType.network => 'error_network',
    FailureType.auth => 'error_unauthorized',
    FailureType.server => 'error_server',
    FailureType.parsing => 'error_unexpected_response',
    FailureType.validation => 'error_request_rejected',
    _ => 'error_unknown',
  };

  bool get isRetryable {
    if (type == FailureType.network) {
      return true;
    }

    if (statusCode == 408 ||
        statusCode == 429 ||
        (statusCode != null && statusCode! >= 500)) {
      return true;
    }

    return false;
  }

  bool get isCritical {
    return this is UnauthorizedFailure ||
        this is AccountDeactivatedFailure ||
        this is SyncAppFailure;
  }

  @override
  String toString() {
    return 'Failure('
        'type: $type, '
        'message: $message, '
        'statusCode: $statusCode, '
        'code: $code'
        ')';
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.network);
}

class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  });
}

class RequestTimeOutFailure extends NetworkFailure {
  const RequestTimeOutFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  });
}

class SendTimeOutFailure extends NetworkFailure {
  const SendTimeOutFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  });
}

class ReceiveTimeOutFailure extends NetworkFailure {
  const ReceiveTimeOutFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.server);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.validation);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please login again.',
    super.statusCode = 401,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.auth);
}

class PaymentFailure extends Failure {
  const PaymentFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.payment);
}

class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.parsing);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.cache);
}

class SyncAppFailure extends Failure {
  const SyncAppFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.sync);
}

class AccountDeactivatedFailure extends Failure {
  const AccountDeactivatedFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.auth);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.statusCode = 404,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.server);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode,
    super.data,
    super.stackTrace,
    super.code,
  }) : super(type: FailureType.unknown);
}
