import '../entities/login_response_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<LoginResponseEntity> execute(String username, String password, String otp) {
    return _repository.login(username, password, otp);
  }
}
