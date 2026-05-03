import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/auth_user.dart';

/// Contract for authentication operations.
///
/// Every method returns a [Result] so callers never need to catch exceptions —
/// errors are surfaced as typed [Failure] values instead.
abstract class AuthRepository {
  /// Initiates phone-number verification and sends an SMS OTP.
  ///
  /// [phoneNumber] must be in E.164 format (e.g. `+15550001234`).
  /// Returns the verificationId (phone number) on success.
  Future<Result<String>> sendOtp({required String phoneNumber});

  /// Verifies the OTP and signs the user in.
  ///
  /// Returns the authenticated [AuthUser] on success.
  Future<Result<AuthUser>> verifyOtp({
    required String phoneNumber,
    required String smsCode,
  });

  /// Sets the MPIN for the given user via a Supabase edge function.
  Future<Result<void>> setMpin({
    required String userId,
    required String rawMpin,
  });

  /// Verifies the MPIN for the given user via a secure server-side RPC.
  ///
  /// Returns `true` if the PIN matches, `false` otherwise.
  Future<Result<bool>> verifyMpin({
    required String userId,
    required String rawMpin,
  });

  /// Returns the authenticated [AuthUser] if a valid session exists,
  /// or `null` if the user is not signed in.
  Future<Result<AuthUser>> hasActiveSession();

  /// Signs the current user out.
  Future<Result<void>> signOut();
}
