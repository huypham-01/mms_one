import 'package:dio/dio.dart';
import '../models/app_update_model.dart';

class AppUpdateRepository {
  final Dio _dio;

  AppUpdateRepository([Dio? dio]) : _dio = dio ?? Dio();

  /// Fetch version list from server and return the first matching key.
  Future<AppUpdateModel?> fetchLatestVersion({String key = 'MMS'}) async {
    try {
      final resp = await _dio.get(
        'http://192.168.110.2/web_develop/landing-page/app_vcm/backend/?c=File&m=listApps&q=MMS',
      );
      if (resp.statusCode == 200 && resp.data is List) {
        final list = resp.data as List;
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final model = AppUpdateModel.fromJson(item);
            if (model.key == key) return model;
          }
        }
      }
      return null;
    } on DioException catch (e) {
      // bubble up null on error but log
      // caller may handle null
      // print debug
      // ignore: avoid_print
      print('[UPDATE] fetchLatestVersion error: ${e.message}');
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('[UPDATE] fetchLatestVersion unknown error: $e');
      return null;
    }
  }
}
