import 'package:dio/dio.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Chuyển đổi DioException thành chuỗi thông điệp tiếng Việt dễ hiểu cho người dùng
  static String parseError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Kết nối quá thời gian quy định. Vui lòng kiểm tra lại mạng.';
        case DioExceptionType.sendTimeout:
          return 'Yêu cầu gửi đi quá thời gian. Vui lòng thử lại.';
        case DioExceptionType.receiveTimeout:
          return 'Phản hồi từ server quá thời gian. Vui lòng thử lại.';
        case DioExceptionType.badCertificate:
          return 'Chứng chỉ bảo mật không hợp lệ.';
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);
        case DioExceptionType.cancel:
          return 'Yêu cầu kết nối đã bị hủy.';
        case DioExceptionType.connectionError:
          return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra internet.';
        case DioExceptionType.unknown:
          if (error.message != null && error.message!.contains('SocketException')) {
            return 'Không có kết nối mạng. Vui lòng kiểm tra lại Wifi/4G.';
          }
          return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.';
      }
    }
    return error?.toString() ?? 'Đã xảy ra lỗi hệ thống.';
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) {
      return 'Không nhận được phản hồi từ hệ thống.';
    }
    
    final statusCode = response.statusCode;
    final dynamic data = response.data;

    // Nếu server trả về message lỗi chi tiết dạng JSON
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'].toString();
    }

    switch (statusCode) {
      case 400:
        return 'Yêu cầu không hợp lệ (400).';
      case 401:
        return 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại (401).';
      case 403:
        return 'Bạn không có quyền thực hiện chức năng này (403).';
      case 404:
        return 'Không tìm thấy dữ liệu yêu cầu (404).';
      case 500:
        return 'Lỗi hệ thống từ server (500). Vui lòng liên hệ quản trị viên.';
      case 502:
        return 'Server Gateway lỗi (502).';
      case 503:
        return 'Hệ thống đang tạm thời quá tải hoặc bảo trì (503).';
      default:
        return 'Lỗi hệ thống ($statusCode). Vui lòng thử lại.';
    }
  }
}
