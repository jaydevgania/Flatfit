import 'package:flutter/foundation.dart';

/// Central crash and error reporting interface.
abstract class CrashReportingService {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  });
  Future<void> log(String message);
  Future<void> setCustomKey(String key, dynamic value);
}

class FlatFitCrashReportingService implements CrashReportingService {
  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      debugPrint('[CrashReporter] Error: $exception');
      if (reason != null) debugPrint('[CrashReporter] Reason: $reason');
      if (stack != null) debugPrint('[CrashReporter] Stack: $stack');
    }
  }

  @override
  Future<void> log(String message) async {
    if (kDebugMode) {
      debugPrint('[CrashReporter Breadcrumb] $message');
    }
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    if (kDebugMode) {
      debugPrint('[CrashReporter Key] $key: $value');
    }
  }
}
