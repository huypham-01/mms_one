import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/transaction_log_model.dart';

abstract class TransactionLogRemoteDataSource {
  Future<List<TransactionLogItemModel>> getTransactionLogs(String mrId);
}

class TransactionLogRemoteDataSourceImpl implements TransactionLogRemoteDataSource {
  final ApiClient _apiClient;

  TransactionLogRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<TransactionLogItemModel>> getTransactionLogs(String mrId) async {
    debugPrint('[TransactionLog] GET mrId=$mrId');

    final response = await _apiClient.get(
      '?c=MrWorkflow&m=consumeEvents&id=$mrId',
    );

    debugPrint('[TransactionLog] Response: ${response.data}');

    final jsonMap = response.data as Map<String, dynamic>;

    if (jsonMap['success'] != true) {
      throw Exception('API returned success=false for transaction log mrId=$mrId');
    }

    final model = TransactionLogModel.fromJson(jsonMap);
    return model.items as List<TransactionLogItemModel>;
  }
}
