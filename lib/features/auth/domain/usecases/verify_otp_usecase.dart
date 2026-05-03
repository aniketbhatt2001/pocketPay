import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthUser>> call({
    required String phoneNumber,
    required String smsCode,
  }) {
    return _repository.verifyOtp(phoneNumber: phoneNumber, smsCode: smsCode);
  }
}
