import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/storage_area_model.dart';

abstract class StorageAreaRemoteDataSource {
  Future<StorageAreaModel> getStorageAreas({
    int page = 1,
  });
}

class StorageAreaRemoteDataSourceImpl implements StorageAreaRemoteDataSource {
  final ApiClient _apiClient;

  StorageAreaRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StorageAreaModel> getStorageAreas({
    int page = 1,
  }) async {
    debugPrint('[StorageArea] GET page=$page');
    
    final response = await _apiClient.get(
      '?c=MrWorkflow&m=pdStorageArea&page=$page',
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
