import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_names.dart';

/// NotificationNavigation — điều hướng khi user CHẠM vào notification.
///
/// Backend gửi kèm `data`: { type, mr_id, mr_no, step }.
/// Vì màn chi tiết MR cần cả entity (không có sẵn từ noti), ở đây điều hướng
/// tới MÀN theo `step` (worklist của bước đó) — hợp lý và chạy được với chỉ
/// mr_id/step. Mobile dev có thể mở rộng để mở đúng MR theo mr_id sau này
/// (fetch entity rồi push MaterialRequestDetailScreen).
class NotificationNavigation {
  NotificationNavigation._();

  /// Xử lý 1 lần chạm noti. [router] là GoRouter của app.
  static void handle(GoRouter router, Map<String, dynamic> data) {
    try {
      final step = data['step']?.toString();
      final path = _pathForStep(step);
      if (path != null) {
        router.go(path);
      } else {
        // planner/reject-tận-gốc/imported... không có màn riêng → về home.
        router.go(RouteNames.homePath);
      }
      debugPrint('[NotificationNavigation] tap data=$data → step=$step');
    } catch (e) {
      debugPrint('[NotificationNavigation] lỗi điều hướng: $e');
    }
  }

  /// Map step (giá trị backend) → route path của màn tương ứng.
  static String? _pathForStep(String? step) {
    switch (step) {
      case 'preparer':
        return RouteNames.preparerPath;
      case 'warehouse':
        return RouteNames.warehousePath;
      case 'receiver':
        return RouteNames.materialReceiverPath;
      case 'line_leader':
        return RouteNames.lineLeaderPath;
      case 'production':
        return RouteNames.toProductionPath;
      default:
        return null;
    }
  }
}
