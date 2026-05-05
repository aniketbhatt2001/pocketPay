import 'package:pocket_pay_demo/core/result/result.dart';

import '../repositories/auth_repository.dart';

/// Returns whether the user already has an active session.
class SetUserProfileUseCase {
  const SetUserProfileUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
  }) => _repository.setUserProfile(
    userId: userId,
    email: email,
    firstName: firstName,
    lastName: lastName,
  );
}
