import 'failure.dart';

/// A lightweight success/failure container used by repositories and services
/// instead of throwing for expected error conditions.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  /// Returns the success value or null.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    ResultFailure<T>() => null,
  };

  /// Returns the failure or null.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(:final failure) => failure,
  };

  /// Folds both cases into a single value.
  R fold<R>(
    R Function(T value) onSuccess,
    R Function(Failure failure) onFailure,
  ) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    ResultFailure<T>(:final failure) => onFailure(failure),
  };
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);
  final Failure failure;
}
