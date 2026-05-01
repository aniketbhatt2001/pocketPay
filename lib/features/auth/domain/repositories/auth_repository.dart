import '../entities/auth_user.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  /// The currently signed-in user, or null if not authenticated.
  AuthUser? get currentUser;

  /// Initiates phone-number verification and sends an SMS OTP.
  ///
  /// [phoneNumber] must be in E.164 format (e.g. `+15550001234`).
  /// Returns the verificationId on success.
  /// Throws a [String] error message on failure.
  Future<String> sendOtp({required String phoneNumber});

  /// Verifies the OTP and signs the user in.
  ///
  /// Returns the authenticated [AuthUser] on success.
  Future<AuthUser> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  /// Sets the MPIN for the given user via a secure server-side RPC.
  Future<void> setMpin({required String userId, required String rawMpin});

  /// Signs the current user out.
  Future<void> signOut();
}
