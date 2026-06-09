class LoginResponseEntity {
  final bool status;
  final String? accessToken;
  final int? expiresIn;

  const LoginResponseEntity({
    required this.status,
    this.accessToken,
    this.expiresIn,
  });
}
