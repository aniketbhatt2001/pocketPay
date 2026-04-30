import '../repositories/splash_repository.dart';

/// Returns whether the user already has an active session.
class CheckSessionUseCase {
  const CheckSessionUseCase(this._repository);

  final SplashRepository _repository;

  Future<bool> call() => _repository.hasActiveSession();
}
