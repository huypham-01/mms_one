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
}
