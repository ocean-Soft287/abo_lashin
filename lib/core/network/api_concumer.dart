import 'dart:async';

import 'package:dio/dio.dart';

import 'auth_interceptor.dart';
import 'dio_error_handler.dart';
import 'either.dart';
import 'failure.dart';

abstract interface class ApiConsumer {
  Future<Either<Failure, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    Duration? receiveTimeout,
  });

  Future<Either<Failure, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> postFormData(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  });

  Future<Either<Failure, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> head(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, dynamic>> downloadFile(
    String endpoint, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<Either<Failure, dynamic>> uploadFile(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? progress,
  });

  void addInterceptor(Interceptor interceptor);

  void removeInterceptor(Interceptor interceptor);

  void clearInterceptors();

  void updateHeader(String key, dynamic value);

  void removeHeader(String key);

  void clearHeaders();

  Future<Either<Failure, dynamic>> retryApiCall(RequestOptions requestOptions);
}

class BaseApiConsumer implements ApiConsumer {
  final Dio _dio;

  final int maxRetries;
  final Duration retryDelay;

  BaseApiConsumer(
    this._dio, {
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  Future<Either<Failure, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    Duration? receiveTimeout,
  }) async {
    return _request(
      () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(
          headers: headers,
          requiresAuth: requiresAuth,
          receiveTimeout: receiveTimeout,
        ),
      ),
      retryGet: true,
    );
  }

  @override
  Future<Either<Failure, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> postFormData(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _request(
      () => _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> head(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.head(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> downloadFile(
    String endpoint, {
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return _request(
      () => _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  Future<Either<Failure, dynamic>> uploadFile(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? progress,
  }) async {
    return _request(
      () => _dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: progress,
        options: _buildOptions(headers: headers, requiresAuth: requiresAuth),
      ),
    );
  }

  @override
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  @override
  void removeInterceptor(Interceptor interceptor) {
    _dio.interceptors.remove(interceptor);
  }

  @override
  void clearInterceptors() {
    _dio.interceptors.clear();
  }

  @override
  void updateHeader(String key, dynamic value) {
    _dio.options.headers[key] = value;
  }

  @override
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  @override
  void clearHeaders() {
    _dio.options.headers.clear();
  }

  @override
  Future<Either<Failure, dynamic>> retryApiCall(
    RequestOptions requestOptions,
  ) async {
    try {
      final response = await _dio.fetch<dynamic>(requestOptions);

      return Right(response.data);
    } on DioException catch (error) {
      return Left(DioErrorHandler.handle(error));
    } catch (error, stackTrace) {
      return Left(
        UnknownFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Either<Failure, dynamic>> _request(
    Future<Response<dynamic>> Function() request, {
    bool retryGet = false,
  }) async {
    var attempt = 0;

    while (true) {
      try {
        final response = await request();

        return Right(_normalizeResponse(response.data));
      } on DioException catch (error) {
        if (retryGet && attempt < maxRetries && _shouldRetry(error)) {
          attempt++;

          await Future.delayed(_calculateRetryDelay(attempt));

          continue;
        }

        return Left(DioErrorHandler.handle(error));
      } catch (error, stackTrace) {
        return Left(
          UnknownFailure(message: error.toString(), stackTrace: stackTrace),
        );
      }
    }
  }

  Options _buildOptions({
    Map<String, dynamic>? headers,
    required bool requiresAuth,
    Duration? receiveTimeout,
  }) {
    return Options(
      headers: headers,
      receiveTimeout: receiveTimeout,
      extra: {AuthInterceptor.requiresAuthKey: requiresAuth},
    );
  }

  bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return false;
    }

    if (statusCode == 408 ||
        statusCode == 429 ||
        (statusCode != null && statusCode >= 500)) {
      return true;
    }

    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  Duration _calculateRetryDelay(int attempt) {
    final milliseconds = retryDelay.inMilliseconds * (1 << (attempt - 1));

    return Duration(milliseconds: milliseconds > 10000 ? 10000 : milliseconds);
  }

  dynamic _normalizeResponse(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'data': data};
  }
}
