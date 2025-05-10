import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      print('[${tag ?? 'APP'}] $message');
    }
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      print('[${tag ?? 'ERROR'}] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }
}
