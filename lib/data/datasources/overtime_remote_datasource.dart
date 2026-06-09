import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/overtime_model.dart';

abstract class OvertimeRemoteDataSource {
  Future<OvertimePageModel> getOvertimes({int page = 1});
}

class OvertimeRemoteDataSourceImpl implements OvertimeRemoteDataSource {
  final ApiClient _apiClient;

  OvertimeRemoteDataSourceImpl(this._apiClient);

  @override
  Future<OvertimePageModel> getOvertimes({int page = 1}) async {
    debugPrint('[Overtime] GET page=$page');

    final response = await _apiClient.get(
      '?c=MrWorkflow&m=overtime&page=$page',
    );

    debugPrint('[Overtime] Response: ${response.data}');

    final jsonMap = response.data as Map<String, dynamic>;

    if (jsonMap['success'] != true) {
      throw Exception('API returned success=false for overtime page=$page');
    }

    final data = jsonMap['data'] as Map<String, dynamic>;
    return OvertimePageModel.fromJson(data);
  }
}
