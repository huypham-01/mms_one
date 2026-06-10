class LoginResponseEntity {
  final bool status;
  final String? accessToken;
  final int? expiresIn;
  final String? message;

  const LoginResponseEntity({
    required this.status,
    this.accessToken,
    this.expiresIn,
    this.message,
  });
}
