import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Log {
  static const bool _withTime = true;
  static final _normalLogger = Logger(
    filter: CustomLogFilter(),
    printer: SimplePrinter(),
  );

  static final _exceptionLogger = Logger(
    filter: CustomLogFilter(),
    printer: PrettyPrinter(methodCount: 8),
  );

  Log._();

  /// Log a message at level [Level.debug].
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _normalLogger.d(_formatMessage(message), error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info].
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _normalLogger.i(_formatMessage(message), error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning].
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _exceptionLogger.w(_formatMessage(message), error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error].
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _exceptionLogger.e(_formatMessage(message), error: error, stackTrace: stackTrace);
  }

  static String _formatMessage(dynamic message) {
    final time = _withTime ? DateFormat('[HH:mm:ss]').format(DateTime.now()) : '';
    return '$time $message';
  }
}

class CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    final flutterTest = Platform.environment.containsKey('FLUTTER_TEST');
    return kDebugMode && !flutterTest;
  }
}
