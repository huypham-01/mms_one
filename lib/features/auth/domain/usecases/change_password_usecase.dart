import '../entities/login_response_entity.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<LoginResponseEntity> execute(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    String otp,
  ) {
    return _repository.setPassword(currentPassword, newPassword, confirmPassword, otp);
  }
}
