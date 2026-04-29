import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the verificationId on success, throws on failure.
  Future<String> call({required String phoneNumber}) {
    return _repository.sendOtp(phoneNumber: phoneNumber);
  }
}
