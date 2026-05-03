import 'package:pocket_pay_demo/core/result/result.dart';

import '../repositories/auth_repository.dart';

class VerifyMpinUseCase {
  const VerifyMpinUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<bool>> call({required String userId, required String rawMpin}) {
    return _repository.verifyMpin(userId: userId, rawMpin: rawMpin);
  }
}
