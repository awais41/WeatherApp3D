import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void logApi(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void logError(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
