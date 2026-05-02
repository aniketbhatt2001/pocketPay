part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

/// Nothing happening yet.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Sending OTP / verifying OTP in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// OTP was sent — navigate to OTP screen.
final class OtpSent extends AuthState {
  const OtpSent(this.phoneNumber);
  final String phoneNumber;
}

/// OTP verified — user is authenticated.
final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);
  final AuthUser user;
}

/// Any error during send or verify.
// final class AuthError extends AuthState {
//   const AuthError(this.message);
//   final String message;
// }
final class AuthUnAuthenticated extends AuthState {
  const AuthUnAuthenticated({this.msg});
  final String? msg;
}
// ── App-start / splash states ─────────────────────────────────────────────

/// Session check is in progress (splash is animating).
// final class AppStartChecking extends AuthState {
//   const AppStartChecking();
// }

// /// Session valid + MPIN set — navigate to wallet.
// final class AppStartAuthenticated extends AuthState {
//   const AppStartAuthenticated();
// }

// /// Session valid but MPIN not yet set — navigate to set-MPIN screen.
// final class AppStartMpinRequired extends AuthState {
//   const AppStartMpinRequired();
// }

// /// No valid session — navigate to login.
// final class AppStartUnauthenticated extends AuthState {
//   const AppStartUnauthenticated();
// }
