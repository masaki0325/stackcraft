import 'dart:developer' as developer;

class Logger {
  static const String _appName = '🔷 StackCraft';

  static void info(String message, {Object? details}) {
    developer.log('💙 INFO: $message', name: _appName, error: details);
  }

  static void success(String message, {Object? details}) {
    developer.log('💚 SUCCESS: $message', name: _appName, error: details);
  }

  static void warning(String message, {Object? details}) {
    developer.log('💛 WARNING: $message', name: _appName, error: details);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      '❌ ERROR: $message',
      name: _appName,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
