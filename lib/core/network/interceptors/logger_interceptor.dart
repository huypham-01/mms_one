import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('==================== API REQUEST ====================');
      debugPrint('--> ${options.method.toUpperCase()} ${options.uri}');
      if (options.headers.isNotEmpty) {
        debugPrint('Headers:');
        options.headers.forEach((key, value) => debugPrint('  $key: $value'));
      }
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Query Params: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
      debugPrint('=====================================================');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('==================== API RESPONSE ===================');
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('Data: ${response.data}');
      debugPrint('=====================================================');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('==================== API ERROR ======================');
      debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Response Error Data: ${err.response?.data}');
      }
      debugPrint('=====================================================');
    }
    super.onError(err, handler);
  }
}
