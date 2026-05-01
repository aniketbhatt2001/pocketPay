import '../repositories/auth_repository.dart';

class SetMpinUseCase {
  const SetMpinUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String userId, required String rawMpin}) {
    return _repository.setMpin(userId: userId, rawMpin: rawMpin);
  }
}
