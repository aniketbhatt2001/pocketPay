// import '../error/failures.dart';

// /// A discriminated union that holds either a successful [value] of type [T]
// /// or a [Failure] describing what went wrong.
// ///
// /// Usage:
// /// ```dart
// /// // Returning from a repository:
// /// Result<AuthUser> result = Result.success(user);
// /// Result<AuthUser> result = Result.failure(SendOtpFailure('Rate limited'));
// ///
// /// // Consuming in a use-case or BLoC:
// /// switch (result) {
// ///   case Success(:final value):
// ///     // use value
// ///   case Failure(:final failure):
// ///     // handle failure.message
// /// }
// ///
// /// // Or with the helper getters:
// /// if (result.isSuccess) print(result.value);
// /// ```
// sealed class Result<T> {
//   const Result();

//   /// Creates a successful result wrapping [value].
//   const factory Result.success(T value) = Success<T>;

//   /// Creates a failed result wrapping [failure].
//   const factory Result.failure(Failure failure) = FailureResult<T>;

//   // ── Convenience getters ──────────────────────────────────────────────────

//   bool get isSuccess => this is Success<T>;
//   bool get isFailure => this is FailureResult<T>;

//   /// The success value, or `null` if this is a failure.
//   T? get valueOrNull => switch (this) {
//     Success(:final value) => value,
//     FailureResult() => null,
//   };
// }

// /// The success variant of [Result].
// final class Success<T> extends Result<T> {
//   const Success(this.value);

//   final T value;

//   @override
//   String toString() => 'Success($value)';
// }

// /// The failure variant of [Result].
// ///
// /// Named [FailureResult] to avoid clashing with the [Failure] domain class.
// final class FailureResult<T> extends Result<T> {
//   const FailureResult(this.failure);

//   final Failure failure;

//   @override
//   String toString() => 'FailureResult(${failure.message})';
// }
import '../error/failures.dart';

/// A discriminated union that holds either a successful [value] of type [T]

/// or a [Failure] describing what went wrong.

///

/// Usage:

/// ```dart

/// // Returning from a repository:

/// Result<AuthUser> result = Result.success(user);

/// Result<AuthUser> result = Result.failure(SendOtpFailure('Rate limited'));

///

/// // Consuming in a use-case or BLoC:

/// switch (result) {

///   case Success(:final value):

///     // use value

///   case Failure(:final failure):

///     // handle failure.message

/// }

///

/// // Or with the helper getters:

/// if (result.isSuccess) print(result.value);

/// ```

sealed class Result<T> {
  const Result();

  /// Creates a successful result wrapping [value].

  const factory Result.success(T value) = Success<T>;

  /// Creates a failed result wrapping [failure].

  const factory Result.failure(Failure failure) = FailureResult<T>;

  R fold<R>({
    required R Function(T value) onSuccess,

    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success(:final value) => onSuccess(value),

    FailureResult(:final failure) => onFailure(failure),
  };
}

/// The success variant of [Result].

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  String toString() => 'Success($value)';
}

/// The failure variant of [Result].

///

/// Named [FailureResult] to avoid clashing with the [Failure] domain class.

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  String toString() => 'FailureResult(${failure.message})';
}
