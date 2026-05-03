import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/auth/domain/entities/auth_user.dart';

import '../repositories/auth_repository.dart';

/// Returns whether the user already has an active session.
class CheckSessionUseCase {
  const CheckSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthUser>> call() => _repository.hasActiveSession();
}
