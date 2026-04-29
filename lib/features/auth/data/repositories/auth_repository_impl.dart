import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final FirebaseAuthService _service;

  @override
  AuthUser? get currentUser {
    final user = _service.currentUser;
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      phoneNumber: user.phoneNumber ?? '',
    );
  }

  @override
  Future<String> sendOtp({required String phoneNumber}) {
    return _service.verifyPhoneNumber(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthUser> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final user = await _service.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      return AuthUser(
        uid: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        createdAt: user.metadata.creationTime,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapCode(e.code));
    }
  }

  @override
  Future<void> signOut() => _service.signOut();

  String _mapCode(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return 'The code you entered is incorrect. Please try again.';
      case 'session-expired':
        return 'The verification code has expired. Please request a new one.';
      default:
        return 'Verification failed. Please try again.';
    }
  }
}
