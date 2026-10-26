import 'dart:convert';

import 'package:dio/dio.dart';

import '../helpers/logger.dart';
import 'app_cipher.dart';

class LoggerInterceptor extends Interceptor {
  static const Set<String> _sensitiveKeys = {
    'authorization',
    'access_token',
    'refresh_token',
    'token',
    'password',
    'confirmpassword',
    'confirm_password',
    'otp',
    'code',
    'secret',
    'api_key',
    'apikey',
    // Decrypted responses carry customer data.
    'customerphone',
    'customer_phone',
    'phone',
    'phonenumber',
    'mobile',
  };

  /// Huge responses (the full catalogue) are cut so the terminal stays
  /// usable.
  static const int _maxLoggedChars = 20000;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger('''
┌──────────── HTTP REQUEST ────────────
│ ${options.method} ${options.uri}
│
│ Headers:
│ ${_formatJson(_sanitize(options.headers))}
${options.queryParameters.isNotEmpty ? '''
│
│ Query:
│ ${_formatJson(_sanitize(options.queryParameters))}
''' : ''}
${options.data != null ? '''
│
│ Body:
│ ${_formatJson(_sanitize(options.data))}
''' : ''}
└──────────────────────────────────────
''');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    loggerInfo('''
┌──────────── HTTP RESPONSE ───────────
│ ${response.requestOptions.method} ${response.requestOptions.uri}
│
│ Status: ${response.statusCode}
│
│ Response:
│ ${_formatJson(_readable(response.data))}
└──────────────────────────────────────
''');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    loggerError('''
┌──────────── HTTP ERROR ──────────────
│ ${err.requestOptions.method} ${err.requestOptions.uri}
│
│ Status: ${err.response?.statusCode}
│ Type: ${err.type}
│ Message: ${err.message}
${err.response?.data != null ? '''
│
│ Response:
│ ${_formatJson(_readable(err.response?.data))}
''' : ''}
└──────────────────────────────────────
''', stackTrace: err.stackTrace);

    handler.next(err);
  }

  dynamic _sanitize(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return value.map((key, value) {
        final keyString = key.toString();

        return MapEntry(
          keyString,
          _isSensitiveKey(keyString) ? '***' : _sanitize(value),
        );
      });
    }

    if (value is Iterable) {
      return value.map(_sanitize).toList();
    }

    if (value is FormData) {
      return {
        'fields': _sanitize(Map.fromEntries(value.fields)),
        'files': value.files.map((file) => file.key).toList(),
      };
    }

    return value;
  }

  bool _isSensitiveKey(String key) {
    final normalizedKey = key
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');

    return _sensitiveKeys.contains(normalizedKey);
  }

  /// A copy of [data] for the log only: an encrypted string body becomes its
  /// decrypted JSON (or text). The response itself is never touched.
  dynamic _readable(dynamic data) {
    if (data is! String) return data;
    var text = data.trim();
    // Unquote a body still in its JSON string form.
    if (text.length >= 2 && text.startsWith('"') && text.endsWith('"')) {
      try {
        final unquoted = jsonDecode(text);
        if (unquoted is String) text = unquoted.trim();
      } on FormatException {
        // Not a JSON string; inspect it as it is.
      }
    }
    if (!_looksEncrypted(text)) return data;
    try {
      final plain = AppCipher.decryptText(text).trim();
      if (plain.isEmpty) return null;
      try {
        return jsonDecode(plain);
      } on FormatException {
        return plain;
      }
    } catch (_) {
      return '<encrypted response could not be decrypted '
          '(${text.length} chars)>';
    }
  }

  /// Ciphertext is Base64 of whole AES blocks; readable text never is, so
  /// plain messages are logged as they are.
  static bool _looksEncrypted(String text) {
    if (text.isEmpty || text.length % 4 != 0) return false;
    try {
      final bytes = base64.decode(text);
      return bytes.isNotEmpty && bytes.length % 16 == 0;
    } on FormatException {
      return false;
    }
  }

  String _formatJson(dynamic value) {
    String formatted;
    try {
      final sanitizedValue = _sanitize(value);

      formatted = const JsonEncoder.withIndent(
        '  ',
      ).convert(sanitizedValue).replaceAll('\n', '\n│ ');
    } catch (_) {
      formatted = value.toString();
    }
    if (formatted.length <= _maxLoggedChars) return formatted;
    return '${formatted.substring(0, _maxLoggedChars)}\n│ … '
        '(${formatted.length - _maxLoggedChars} more characters)';
  }
}
