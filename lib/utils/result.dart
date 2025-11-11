/// Result type for uniform error handling across services
/// Either a Success with data or an Error with message
sealed class Result<T> {
  const Result();

  /// Create a successful result with data
  factory Result.success(T data) => Success(data);

  /// Create an error result with message
  factory Result.error(String message) => Error(message);

  /// Transform result with a function
  Result<R> map<R>(R Function(T data) transform) {
    return when(
      success: (data) => Result.success(transform(data)),
      error: (message) => Result.error(message),
    );
  }

  /// Transform result asynchronously
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) transform) async {
    return when(
      success: (data) async => Result.success(await transform(data)),
      error: (message) async => Result.error(message),
    );
  }

  /// Chain results together (flatMap)
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return when(
      success: (data) => transform(data),
      error: (message) => Result.error(message),
    );
  }

  /// Chain results asynchronously
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return when(
      success: (data) async => await transform(data),
      error: (message) async => Result.error(message),
    );
  }

  /// Get data or return default value
  T getOrElse(T defaultValue) {
    return when(success: (data) => data, error: (_) => defaultValue);
  }

  /// Get data or null
  T? getOrNull() {
    return when(success: (data) => data, error: (_) => null);
  }

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Pattern matching on result
  R when<R>({
    required R Function(T data) success,
    required R Function(String message) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return error((this as Error<T>).message);
    }
  }

  /// Pattern matching with async functions
  Future<R> whenAsync<R>({
    required Future<R> Function(T data) success,
    required Future<R> Function(String message) error,
  }) async {
    if (this is Success<T>) {
      return await success((this as Success<T>).data);
    } else {
      return await error((this as Error<T>).message);
    }
  }

  /// Execute side effect if success
  Result<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute side effect if error
  Result<T> onError(void Function(String message) action) {
    if (this is Error<T>) {
      action((this as Error<T>).message);
    }
    return this;
  }

  /// Execute side effect asynchronously if success
  Future<Result<T>> onSuccessAsync(Future<void> Function(T data) action) async {
    if (this is Success<T>) {
      await action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute side effect asynchronously if error
  Future<Result<T>> onErrorAsync(
    Future<void> Function(String message) action,
  ) async {
    if (this is Error<T>) {
      await action((this as Error<T>).message);
    }
    return this;
  }
}

/// Success result with data
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

/// Error result with message
final class Error<T> extends Result<T> {
  final String message;

  const Error(this.message);

  @override
  String toString() => 'Error($message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Error<T> && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// Extension methods for `Future<Result<T>>`
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Map over future result
  Future<Result<R>> map<R>(R Function(T data) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// FlatMap over future result
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    final result = await this;
    return result.flatMapAsync(transform);
  }

  /// Get data or default value
  Future<T> getOrElse(T defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Get data or null
  Future<T?> getOrNull() async {
    final result = await this;
    return result.getOrNull();
  }

  /// Handle result with async callbacks
  Future<R> when<R>({
    required Future<R> Function(T data) success,
    required Future<R> Function(String message) error,
  }) async {
    final result = await this;
    return result.whenAsync(success: success, error: error);
  }
}

/// Helper functions for creating results
class ResultHelper {
  ResultHelper._();

  /// Try to execute a function and return result
  static Result<T> tryCatch<T>(
    T Function() fn, {
    String Function(dynamic error)? errorMapper,
  }) {
    try {
      return Result.success(fn());
    } catch (e) {
      final message = errorMapper?.call(e) ?? e.toString();
      return Result.error(message);
    }
  }

  /// Try to execute an async function and return result
  static Future<Result<T>> tryCatchAsync<T>(
    Future<T> Function() fn, {
    String Function(dynamic error)? errorMapper,
  }) async {
    try {
      final data = await fn();
      return Result.success(data);
    } catch (e) {
      final message = errorMapper?.call(e) ?? e.toString();
      return Result.error(message);
    }
  }

  /// Combine multiple results into one
  /// Returns success only if all results are successful
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final data = <T>[];

    for (final result in results) {
      if (result.isError) {
        return Result.error((result as Error<T>).message);
      }
      data.add((result as Success<T>).data);
    }

    return Result.success(data);
  }

  /// Combine multiple async results
  static Future<Result<List<T>>> combineAsync<T>(
    List<Future<Result<T>>> futures,
  ) async {
    final results = await Future.wait(futures);
    return combine(results);
  }
}
