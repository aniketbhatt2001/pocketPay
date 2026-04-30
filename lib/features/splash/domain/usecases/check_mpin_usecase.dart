import '../repositories/splash_repository.dart';

/// Returns whether the authenticated user has already configured an MPIN.
class CheckMpinUseCase {
  const CheckMpinUseCase(this._repository);

  final SplashRepository _repository;

  Future<bool> call() => _repository.isMpinSet();
}
