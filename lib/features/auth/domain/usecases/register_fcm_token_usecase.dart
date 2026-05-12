import 'package:pocket_pay_demo/core/result/result.dart';
import '../repositories/auth_repository.dart';

class RegisterFcmTokenUseCase {
  const RegisterFcmTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({required String userId}) =>
      _repository.registerFcmToken(userId: userId);
}
