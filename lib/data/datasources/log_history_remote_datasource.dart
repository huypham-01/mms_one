import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/log_history_model.dart';

abstract class LogHistoryRemoteDataSource {
  Future<List<LogHistoryItemModel>> getLogHistory(String mrId);
}

class LogHistoryRemoteDataSourceImpl implements LogHistoryRemoteDataSource {
  final ApiClient _apiClient;

  LogHistoryRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<LogHistoryItemModel>> getLogHistory(String mrId) async {
    debugPrint('[LogHistory] GET mrId=$mrId');

    final response = await _apiClient.get(
      '?c=MrWorkflow&m=auditLog&id=$mrId',
    );

    debugPrint('[LogHistory] Response: ${response.data}');

    final jsonMap = response.data as Map<String, dynamic>;

    if (jsonMap['success'] != true) {
      throw Exception(
        'API returned success=false for log history mrId=$mrId',
      );
    }

    final model = LogHistoryModel.fromJson(jsonMap);
    return model.items.cast<LogHistoryItemModel>();
  }
}
