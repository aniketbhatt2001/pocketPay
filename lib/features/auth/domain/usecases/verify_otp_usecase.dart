import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({
    required String verificationId,
    required String smsCode,
  }) {
    return _repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
