import 'dart:io';

import 'package:dio/dio.dart';

import '../../network/either.dart';
import '../../network/failure.dart';
import '../api_concumer.dart';

class GenericDataSource {
  final ApiConsumer _apiConsumer;

  const GenericDataSource(this._apiConsumer);

  Future<Either<Failure, List<T>>> fetchData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return result.fold(Left.new, (data) {
      try {
        final list = _extractList(data);

        return Right(
          list
              .whereType<Map>()
              .map((item) => fromJson(Map<String, dynamic>.from(item)))
              .toList(),
        );
      } catch (error, stackTrace) {
        return Left(
          ParsingFailure(
            message: error.toString(),
            stackTrace: stackTrace,
            data: data,
          ),
        );
      }
    });
  }

  Future<Either<Failure, T>> fetchResult<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return _parseResponse(result, fromJson: fromJson);
  }

  Future<Either<Failure, T>> postData<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return _parseResponse(result, fromJson: fromJson);
  }

  Future<Either<Failure, T>> postFormData<T>({
    required String endpoint,
    required Map<String, dynamic> fields,
    Map<String, dynamic>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? progress,
  }) async {
    try {
      final formData = await _processFormData(fields: fields, files: files);

      final result = await _apiConsumer.uploadFile(
        endpoint,
        formData: formData,
        queryParameters: queryParameters,
        headers: headers,
        requiresAuth: requiresAuth,
        cancelToken: cancelToken,
        progress: progress,
      );

      return _parseResponse(result, fromJson: fromJson);
    } catch (error, stackTrace) {
      return Left(
        ParsingFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Either<Failure, T>> deleteData<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return _parseResponse(result, fromJson: fromJson);
  }

  Future<Either<Failure, T>> patchData<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.patch(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return _parseResponse(result, fromJson: fromJson);
  }

  Future<Either<Failure, T>> updateData<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return _parseResponse(result, fromJson: fromJson);
  }

  Future<Either<Failure, T>> updateMultipartData<T>({
    required String endpoint,
    required Map<String, dynamic> fields,
    Map<String, dynamic>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? progress,
  }) async {
    try {
      final formData = await _processFormData(fields: fields, files: files);

      final result = await _apiConsumer.uploadFile(
        endpoint,
        formData: formData,
        queryParameters: queryParameters,
        headers: headers,
        requiresAuth: requiresAuth,
        cancelToken: cancelToken,
        progress: progress,
      );

      return _parseResponse(result, fromJson: fromJson);
    } catch (error, stackTrace) {
      return Left(
        ParsingFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Either<Failure, PaginationResponse<T>>> fetchPaginationData<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required T Function(Map<String, dynamic>) fromJson,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );

    return result.fold(Left.new, (data) {
      try {
        final map = _asMap(data);

        final list = _extractList(
          map['data'] ?? map['result'] ?? map['items'] ?? map,
        );

        final items =
            list
                .whereType<Map>()
                .map((item) => fromJson(Map<String, dynamic>.from(item)))
                .toList();

        final total = _toInt(map['total'] ?? map['totalCount'] ?? map['count']);

        final page =
            _toInt(map['page'] ?? map['currentPage'] ?? map['pageNumber']) ?? 1;

        final pageSize =
            _toInt(map['pageSize'] ?? map['page_size'] ?? map['limit']) ??
            items.length;

        return Right(
          PaginationResponse<T>(
            items: items,
            total: total ?? items.length,
            page: page,
            pageSize: pageSize,
          ),
        );
      } catch (error, stackTrace) {
        return Left(
          ParsingFailure(
            message: error.toString(),
            stackTrace: stackTrace,
            data: data,
          ),
        );
      }
    });
  }

  Future<Either<Failure, dynamic>> head({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) {
    return _apiConsumer.head(
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      requiresAuth: requiresAuth,
      cancelToken: cancelToken,
    );
  }

  Future<Either<Failure, T>> _parseResponse<T>(
    Either<Failure, dynamic> result, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return result.fold(Left.new, (data) {
      try {
        if (T == Null) {
          return Right(data as T);
        }

        if (T == String) {
          return Right(_extractString(data) as T);
        }

        if (T == int) {
          return Right(_extractInt(data) as T);
        }

        if (fromJson == null) {
          throw StateError('fromJson is required for model response.');
        }

        final map = _asMap(_extractResponseData(data));

        return Right(fromJson(map));
      } catch (error, stackTrace) {
        return Left(
          ParsingFailure(
            message: error.toString(),
            stackTrace: stackTrace,
            data: data,
          ),
        );
      }
    });
  }

  dynamic _extractResponseData(dynamic response) {
    if (response is Map) {
      return response['data'] ?? response['result'] ?? response;
    }

    return response;
  }

  String _extractString(dynamic response) {
    if (response is String) {
      return response;
    }

    if (response is Map) {
      final value =
          response['data'] ??
          response['result'] ??
          response['message'] ??
          response['redirect_url'] ??
          response['url'];

      return value?.toString() ?? '';
    }

    return response?.toString() ?? '';
  }

  int _extractInt(dynamic response) {
    if (response is int) {
      return response;
    }

    if (response is num) {
      return response.toInt();
    }

    if (response is Map) {
      final value = response['id'] ?? response['data'] ?? response['result'];

      if (value is num) {
        return value.toInt();
      }

      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return int.tryParse(response?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw FormatException('Expected Map but received ${value.runtimeType}.');
  }

  List<dynamic> _extractList(dynamic value) {
    if (value is List) {
      return value;
    }

    if (value is Map) {
      final nested = value['data'] ?? value['result'] ?? value['items'];

      if (nested is List) {
        return nested;
      }
    }

    throw FormatException('Expected List but received ${value.runtimeType}.');
  }

  int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '');
  }

  Future<FormData> _processFormData({
    required Map<String, dynamic> fields,
    Map<String, dynamic>? files,
  }) async {
    final formFields = <MapEntry<String, String>>[];

    for (final entry in fields.entries) {
      if (entry.value == null) {
        continue;
      }

      formFields.add(MapEntry(entry.key, entry.value.toString()));
    }

    final multipartFiles = <MapEntry<String, MultipartFile>>[];

    if (files != null) {
      for (final entry in files.entries) {
        final value = entry.value;

        if (value == null) {
          continue;
        }

        if (value is File) {
          multipartFiles.add(
            MapEntry(entry.key, await MultipartFile.fromFile(value.path)),
          );

          continue;
        }

        if (value is MultipartFile) {
          multipartFiles.add(MapEntry(entry.key, value));

          continue;
        }

        if (value is List<File>) {
          for (final file in value) {
            multipartFiles.add(
              MapEntry(entry.key, await MultipartFile.fromFile(file.path)),
            );
          }
        }
      }
    }

    return FormData.fromMap({
      ...Map.fromEntries(formFields),
      ...Map.fromEntries(multipartFiles),
    });
  }
}

class PaginationResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  const PaginationResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore {
    if (pageSize <= 0) {
      return false;
    }

    return page * pageSize < total;
  }
}
