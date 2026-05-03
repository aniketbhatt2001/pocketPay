import 'package:pocket_pay_demo/core/result/result.dart';

import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the verificationId on success, throws on failure.
  Future<Result<String>> call({required String phoneNumber}) {
    return _repository.sendOtp(phoneNumber: phoneNumber);
  }
}
