import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import '../auth/token_manager.dart';
import '../auth/jwt_helper.dart';

class DioClient {
  final String baseUrl;
  final TokenManager tokenManager;
  final Future<void> Function()? onLogoutRequired;
  
  late final Dio dio;

  DioClient({
    required this.baseUrl,
    required this.tokenManager,
    this.onLogoutRequired,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenManager),
      // Auto Logout Check: Interceptor kiểm tra JWT expiry trước khi gọi request
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Bỏ qua check JWT cho API login
          if (options.path.contains('c=Auth&m=login')) {
            return handler.next(options);
          }

          final token = tokenManager.getToken();
          if (token != null && JwtHelper.isExpired(token)) {
            debugPrint('[DioClient] Token expired, executing auto logout.');
            await tokenManager.clearToken();
            if (onLogoutRequired != null) {
              await onLogoutRequired!();
            }
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Token has expired',
                type: DioExceptionType.cancel,
              ),
            );
          }
          return handler.next(options);
        },
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          // Xử lý logic 401 chung ở đây
          if (err.response?.statusCode == 401) {
             debugPrint('[DioClient] 401 Unauthorized, executing auto logout.');
             await tokenManager.clearToken();
             if (onLogoutRequired != null) {
                await onLogoutRequired!();
             }
          }
          return handler.next(err);
        }
      ),
      LoggerInterceptor(),
    ]);
  }
}
