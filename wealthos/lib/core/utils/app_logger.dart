import 'package:flutter/foundation.dart';

/// Minimal logging facade that is active only in debug/profile builds.
///
/// Financial amounts and account details must never be passed here — logs are
/// for control-flow and error diagnostics only. In release builds every call
/// is a no-op so nothing sensitive can leak to device logs.
abstract final class AppLogger {
  static void debug(String message) {
    if (kReleaseMode) return;
    debugPrint('[wealthos] $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    if (kReleaseMode) return;
    debugPrint(
      '[wealthos][error] $message${error == null ? '' : ' :: $error'}',
    );
    if (stack != null) debugPrintStack(stackTrace: stack);
  }
}
