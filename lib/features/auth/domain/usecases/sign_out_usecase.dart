import 'package:pocket_pay_demo/core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Signs the current user out and clears the session.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.signOut();
}
