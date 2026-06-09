import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../models/workflow_item_model.dart';

class WorkflowService {
  final ApiClient _apiClient;

  WorkflowService(this._apiClient);

  /// Lấy danh sách Material Requests chờ xử lý theo từng Step (preparer, warehouse, receiver...)
  Future<List<WorkflowItemModel>> fetchWorkflowItems(String step) async {
    final response = await _apiClient.get(
      '/mr-requests/workflow',
      queryParameters: {'step': step},
    );

    final dynamic data = response.data;
    if (data is List) {
      return data.map((json) => WorkflowItemModel.fromJson(json)).toList();
    } else if (data is Map<String, dynamic> && data.containsKey('items')) {
      final items = data['items'] as List;
      return items.map((json) => WorkflowItemModel.fromJson(json)).toList();
    }
    return [];
  }

  /// Upload ảnh xác thực (Verification Picture)
  Future<String?> uploadImage(File file) async {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await _apiClient.post(
      '/upload',
      data: formData,
    );

    final dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      // Trả về file path được upload lên server
      return data['file_path'] ?? data['path'] ?? data['first_path'];
    }
    return null;
  }

  /// Submit dữ liệu workflow theo Endpoint tương ứng với từng Step
  Future<void> submit({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    await _apiClient.post(endpoint, data: body);
  }

  /// Từ chối (Reject) workflow hiện tại
  Future<void> reject({
    required String step,
    required String mrRequestId,
    required String reason,
    required String otp,
  }) async {
    await _apiClient.post(
      '/mr-requests/reject',
      data: {
        'step': step,
        'mr_request_id': mrRequestId,
        'reject_reason': reason,
        'otp': otp,
      },
    );
  }
}
