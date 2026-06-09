import '../entities/login_response_entity.dart';

abstract class AuthRepository {
  Future<LoginResponseEntity> login(String username, String password, String otp);
  Future<void> logout();
  Future<bool> checkLoginStatus();
}
