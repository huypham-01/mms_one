import '../repositories/auth_repository.dart';

class CheckLoginStatusUseCase {
  final AuthRepository _repository;

  CheckLoginStatusUseCase(this._repository);

  Future<bool> execute() {
    return _repository.checkLoginStatus();
  }
}
