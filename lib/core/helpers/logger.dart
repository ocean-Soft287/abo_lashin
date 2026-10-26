import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

void logger(dynamic message) => _log(message, level: 500);

void loggerInfo(dynamic message) => _log(message, level: 800);

void loggerWarn(dynamic message) => _log(message, level: 900);

void loggerVerbose(dynamic message) => _log(message, level: 300);

void loggerFatal(dynamic message) => _log(message, level: 1200);

void loggerError(dynamic error, {StackTrace? stackTrace}) {
  if (!kDebugMode) return;
  developer.log(
    '$error',
    name: 'abolashin',
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );
}

void _log(dynamic message, {required int level}) {
  if (!kDebugMode) return;
  developer.log('$message', name: 'abolashin', level: level);
}
