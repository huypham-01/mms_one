import 'package:dio/dio.dart';
import '../../auth/token_manager.dart';

class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Không đính kèm token nếu đang gọi API Login
    if (options.path.contains('/auth/login') || options.path.contains('c=Auth&m=login')) {
      return super.onRequest(options, handler);
    }

    if (_tokenManager.hasToken()) {
      final token = _tokenManager.getToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }
}
