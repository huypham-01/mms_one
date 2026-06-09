import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../core/auth/token_manager.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenManager);

  @override
  Future<LoginResponseEntity> login(String username, String password, String otp) async {
    final response = await _remoteDataSource.login(username, password, otp);
    
    // Nếu login thành công, lưu token vào storage
    if (response.status && response.accessToken != null) {
      await _tokenManager.saveToken(response.accessToken!);
    }
    
    return response;
  }

  @override
  Future<void> logout() async {
    await _tokenManager.clearToken();
  }

  @override
  Future<bool> checkLoginStatus() async {
    final token = _tokenManager.getToken();
    if (token != null && token.isNotEmpty) {
      if (JwtDecoder.isExpired(token)) {
        await logout();
        return false;
      } else {
        return true;
      }
    }
    return false;
  }
}
