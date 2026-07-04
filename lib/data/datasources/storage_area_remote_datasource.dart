import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/storage_area_model.dart';

abstract class StorageAreaRemoteDataSource {
  Future<StorageAreaModel> getStorageAreas({
    int page = 1,
    String? status,
  });
}

class StorageAreaRemoteDataSourceImpl implements StorageAreaRemoteDataSource {
  final ApiClient _apiClient;

  StorageAreaRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StorageAreaModel> getStorageAreas({
    int page = 1,
    String? status,
  }) async {
    debugPrint('[StorageArea] GET page=$page status=$status');

    final statusParam = (status != null && status.isNotEmpty) ? '&status=$status' : '';
    final response = await _apiClient.get(
      '?c=MrWorkflow&m=pdStorageArea&page=$page$statusParam',
    );
    
    debugPrint('[StorageArea] Response: ${response.data}');

    final jsonMap = response.data as Map<String, dynamic>;

    if (jsonMap['success'] != true) {
      throw Exception('API returned success=false for storage area page=$page');
    }

    final data = jsonMap['data'] as Map<String, dynamic>;
    return StorageAreaModel.fromJson(data);
  }
}
