import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// FcmTopicService — subscribe/unsubscribe FCM topic theo ROLE của user.
///
/// Backend bắn notification theo topic `role_<name>` (xem
/// docs/FCM_MOBILE_HANDOFF.md). App chỉ cần subscribe topic ứng với (các) role
/// lấy từ JWT.
///
/// JWT claim `role` là 1 MẢNG object: [{ "uuid": ..., "name": "admin", ... }]
/// → topic = 'role_' + name (đồng nhất cho cả 7 role, không cần map tay).
///
/// Tất cả method đều best-effort: lỗi mạng/Firebase KHÔNG được làm hỏng luồng
/// đăng nhập/đăng xuất → bọc try/catch, chỉ log.
class FcmTopicService {
  FcmTopicService._();

  /// Rút danh sách role name từ JWT. Vd: ['admin'] / ['line_leader'].
  static List<String> rolesFromToken(String? token) {
    if (token == null || token.isEmpty) return const [];
    try {
      final decoded = JwtDecoder.decode(token);
      final roles = decoded['role'];
      if (roles is List) {
        return roles
            .map((e) =>
                (e is Map && e['name'] != null) ? e['name'].toString() : null)
            .whereType<String>()
            .where((name) => name.isNotEmpty)
            .toList();
      }
    } catch (e) {
      debugPrint('[FcmTopicService] decode role lỗi: $e');
    }
    return const [];
  }

  /// Subscribe topic cho mọi role trong token. Gọi sau khi login thành công
  /// và khi mở lại app mà đã đăng nhập sẵn.
  static Future<void> subscribeForToken(String? token) async {
    for (final role in rolesFromToken(token)) {
      final topic = 'role_$role';
      try {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        debugPrint('[FcmTopicService] subscribed: $topic');
      } catch (e) {
        debugPrint('[FcmTopicService] subscribe $topic lỗi: $e');
      }
    }
  }

  /// Unsubscribe topic cho mọi role trong token. Gọi khi logout
  /// (LƯU Ý: gọi khi token còn hiệu lực, TRƯỚC khi clear token).
  static Future<void> unsubscribeForToken(String? token) async {
    for (final role in rolesFromToken(token)) {
      final topic = 'role_$role';
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
        debugPrint('[FcmTopicService] unsubscribed: $topic');
      } catch (e) {
        debugPrint('[FcmTopicService] unsubscribe $topic lỗi: $e');
      }
    }
  }
}
