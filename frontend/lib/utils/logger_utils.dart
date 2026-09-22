import 'package:flutter/foundation.dart';

class LoggerUtils {
  LoggerUtils._();

  static void info(String message, [Object? data]) {
    _log('INFO', message, data);
  }

  static void success(String message, [Object? data]) {
    _log('SUCCESS', message, data);
  }

  static void warning(String message, [Object? data]) {
    _log('WARNING', message, data);
  }

  static void error(
      String message, [
        Object? error,
        StackTrace? stackTrace,
      ]) {
    _log('ERROR', message, error);

    if (stackTrace != null && kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static void debug(String message, [Object? data]) {
    if (!kDebugMode) {
      return;
    }

    _log('DEBUG', message, data);
  }

  static void _log(
      String level,
      String message,
      Object? data,
      ) {
    final timestamp = DateTime.now().toIso8601String();

    final buffer = StringBuffer()
      ..write('[$timestamp] ')
      ..write('[$level] ')
      ..write(message);

    if (data != null) {
      buffer.write(' | $data');
    }

    debugPrint(buffer.toString());
  }
}