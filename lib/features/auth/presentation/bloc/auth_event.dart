part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

/// User tapped "Continue" on the login screen.
final class SendOtpRequested extends AuthEvent {
  const SendOtpRequested(this.phoneNumber);
  final String phoneNumber; // E.164 format
}

/// User submitted the 6-digit OTP.
final class VerifyOtpRequested extends AuthEvent {
  const VerifyOtpRequested(this.smsCode);
  final String smsCode;
}

/// User tapped "Resend" on the OTP screen.
final class ResendOtpRequested extends AuthEvent {
  const ResendOtpRequested();
}

/// Reset back to initial state (e.g. user navigates back).
final class AuthReset extends AuthEvent {
  const AuthReset();
}
