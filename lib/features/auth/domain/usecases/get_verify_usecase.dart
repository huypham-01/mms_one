import '../repositories/auth_repository.dart';

class GetVerifyUseCase {
  final AuthRepository _repository;

  GetVerifyUseCase(this._repository);

  Future<bool> execute(String username) {
    return _repository.getVerify(username);
  }
}
