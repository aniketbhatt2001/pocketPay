part of 'mpin_cubit.dart';

sealed class MpinState {
  const MpinState();
}

/// Idle — waiting for user input.
final class MpinInitial extends MpinState {
  const MpinInitial();
}

/// RPC call in-flight.
final class MpinLoading extends MpinState {
  const MpinLoading();
}

/// MPIN saved successfully.
final class MpinSuccess extends MpinState {
  const MpinSuccess();
}

/// Something went wrong.
final class MpinError extends MpinState {
  const MpinError(this.message);
  final String message;
}
