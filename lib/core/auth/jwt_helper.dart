import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  JwtHelper._();

  /// Kiểm tra token có bị hết hạn hay chưa
  static bool isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // Nếu lỗi parse token, coi như hết hạn
    }
  }

  /// Lấy ngày hết hạn của token
  static DateTime? getExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }
}
