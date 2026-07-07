import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<LoginResponseModel> login(
    String username,
    String password,
    String otp,
  ) async {
    final response = await _apiClient.post(
      '?c=Auth&m=login',
      data: {'username': username, 'password': password, 'otp': otp},
    );

    return LoginResponseModel.fromJson(response.data);
  }

  Future<LoginResponseModel> setPassword(
    String currentPassword,
    String password,
    String confirmPassword,
    String otp,
  ) async {
    final response = await _apiClient.post(
      '?c=Auth&m=setPassword',
      data: {
        'current_password': currentPassword,
        'password': password,
        'confirm_password': confirmPassword,
        'otp': otp,
      },
    );

    return LoginResponseModel.fromJson(response.data);
  }
}
