import '../../domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.status,
    super.accessToken,
    super.expiresIn,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginResponseModel(
      status: json['status'] ?? false,
      accessToken: data?['access_token'] as String?,
      expiresIn: data?['expires_in'] as int?,
    );
  }
}
