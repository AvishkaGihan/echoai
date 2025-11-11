import 'dart:developer' as developer;

/// Simple logging utility using dart:developer
class Logger {
  static const String _name = 'EchoAI';

  /// Log error messages
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _name,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info messages
  static void info(String message) {
    developer.log(
      message,
      name: _name,
      level: 800, // Info level
    );
  }

  /// Log debug messages
  static void debug(String message) {
    developer.log(
      message,
      name: _name,
      level: 500, // Debug level
    );
  }
}
