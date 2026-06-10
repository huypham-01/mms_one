class MockConstants {
  static const String mockUsername = 'test';
  static const String mockPassword = 'test123';
  static const String mockOtp = '111111';

  // Base64 encoded payload: {"username":"test","fullName":"Mock User","role":"Administrator","exp":9999999999}
  static const String mockToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJmdWxsTmFtZSI6Ik1vY2sgVXNlciIsInJvbGUiOiJBZG1pbmlzdHJhdG9yIiwiZXhwIjo5OTk5OTk5OTk5fQ.mock_signature';
}
