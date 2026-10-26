import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../api_concumer.dart';
import '../app_cipher.dart';
import '../either.dart';
import '../failure.dart';

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class EncryptedDataSource {
  static const int _backgroundDecodeThreshold = 64 * 1024;

  final ApiConsumer _apiConsumer;

  const EncryptedDataSource(this._apiConsumer);

  Future<Either<Failure, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Duration? receiveTimeout,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: queryParameters,
      receiveTimeout: receiveTimeout,
    );
    return _decodeResult(result);
  }

  Future<Either<Failure, List<T>>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    required JsonFactory<T> fromJson,
    Duration? receiveTimeout,
  }) async {
    final result = await get(
      endpoint,
      queryParameters: queryParameters,
      receiveTimeout: receiveTimeout,
    );
    return result.fold(Left.new, (data) => parseList(data, fromJson));
  }

  Future<Either<Failure, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool decryptResponse = true,
  }) async {
    final result = await _apiConsumer.post(endpoint, data: _encryptBody(body));
    return decryptResponse ? _decodeResult(result) : _unwrapResult(result);
  }

  Future<Either<Failure, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool decryptResponse = true,
  }) async {
    final result = await _apiConsumer.put(endpoint, data: _encryptBody(body));
    return decryptResponse ? _decodeResult(result) : _unwrapResult(result);
  }

  Future<Either<Failure, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final result = await _apiConsumer.delete(
      endpoint,
      queryParameters: queryParameters,
    );
    return _unwrapResult(result);
  }

  Future<Either<Failure, dynamic>> getRaw(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final result = await _apiConsumer.get(
      endpoint,
      queryParameters: queryParameters,
    );
    return _unwrapResult(result);
  }

  static Either<Failure, List<T>> parseList<T>(
    dynamic data,
    JsonFactory<T> fromJson,
  ) {
    if (data == null) return const Right([]);
    if (data is! List) {
      return Left(
        ParsingFailure(
          message: 'Expected a list but received ${data.runtimeType}.',
          data: data,
        ),
      );
    }
    try {
      return Right(
        data
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
  }

  static String _encryptBody(Map<String, dynamic> body) =>
      jsonEncode(AppCipher.encryptMap(body));

  static Either<Failure, dynamic> _unwrapResult(
    Either<Failure, dynamic> result,
  ) {
    return result.fold(Left.new, (data) => Right(_unwrap(data)));
  }

  static Future<Either<Failure, dynamic>> _decodeResult(
    Either<Failure, dynamic> result,
  ) {
    return result.fold(
      (failure) async => Left(failure),
      (data) => _decode(_unwrap(data)),
    );
  }

  static dynamic _unwrap(dynamic data) {
    if (data is Map && data.length == 1 && data.containsKey('data')) {
      return data['data'];
    }
    return data;
  }

  static Future<Either<Failure, dynamic>> _decode(dynamic data) async {
    if (data is! String) return Right(data);
    try {
      final decoded =
          data.length > _backgroundDecodeThreshold
              ? await compute(decryptAndParse, data)
              : decryptAndParse(data);
      return Right(decoded);
    } catch (error, stackTrace) {
      return Left(
        ParsingFailure(
          message: error.toString(),
          stackTrace: stackTrace,
          data: data,
        ),
      );
    }
  }

  @visibleForTesting
  static dynamic decryptAndParse(String encrypted) {
    final plain = AppCipher.decryptText(encrypted);
    final trimmed = plain.trim();
    if (trimmed.isEmpty) return null;
    try {
      return jsonDecode(trimmed);
    } on FormatException {
      return plain;
    }
  }
}
