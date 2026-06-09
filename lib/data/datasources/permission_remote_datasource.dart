import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/permission_model.dart';

abstract class PermissionRemoteDataSource {
  Future<Set<String>> getMyPermissions();
}

class PermissionRemoteDataSourceImpl implements PermissionRemoteDataSource {
  final ApiClient apiClient;

  PermissionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<Set<String>> getMyPermissions() async {
    debugPrint('[Permission] GET permissions');
    final response = await apiClient.get<Map<String, dynamic>>('?c=User&m=getMyPermissions');
    
    if (response.data != null) {
      final model = PermissionModel.fromJson(response.data!);
      debugPrint('[Permission] Permissions loaded: ${model.permissions}');
      return model.permissions;
    }
    return <String>{};
  }
}
