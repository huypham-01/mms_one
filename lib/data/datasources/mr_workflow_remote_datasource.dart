import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/mr_workflow_response_model.dart';
import '../models/workflow_report_model.dart';

/// Remote data source cho MR Workflow API.
/// Endpoint: ?c=MrWorkflow&m=byStep&step={step}&page={page}
class MrWorkflowRemoteDataSource {
  final ApiClient _apiClient;

  MrWorkflowRemoteDataSource(this._apiClient);

  Future<MrWorkflowResponseModel> getByStep({
    required String step,
    int page = 1,
  }) async {
    debugPrint('[MrWorkflow] GET step=$step page=$page');

    final response = await _apiClient.get(
      '?c=MrWorkflow&m=byStep&step=$step&page=$page',
    );

    final jsonMap = response.data as Map<String, dynamic>;

    if (jsonMap['success'] != true) {
      throw Exception('API returned success=false for step=$step page=$page');
    }

    final model = MrWorkflowResponseModel.fromJson(jsonMap);
    debugPrint(
      '[MrWorkflow] Parsed ${model.data.length} items '
      '(page ${model.currentPage}/${model.lastPage}, total=${model.total})',
    );
    return model;
  }

  Future<WorkflowReportModel?> getReportDetail(String id, String step) async {
    final url = '?c=MaterialRequestManager&m=steps&id=$id&step=$step';
    debugPrint('[MrWorkflow] Request URL: $url');

    try {
      final response = await _apiClient.get(url);
      debugPrint('[MrWorkflow] Raw response: ${response.data}');

      final jsonMap = response.data as Map<String, dynamic>;

      if (jsonMap['success'] != true) {
        debugPrint(
          '[MrWorkflow] API returned success=false for id=$id step=$step',
        );
        return null;
      }

      final data = jsonMap['data'] as Map<String, dynamic>?;
      if (data == null) {
        debugPrint('[MrWorkflow] Data field is null for id=$id step=$step');
        return null;
      }

      final items = data['data'] as List<dynamic>? ?? [];

      if (items.isEmpty) {
        debugPrint(
          '[MrWorkflow] No report detail found (Empty List) for '
          'id=$id step=$step, total=${data['total']}, itemCount=${items.length}',
        );
        return null;
      }

      final model = WorkflowReportModel.fromJson(
        items.first as Map<String, dynamic>,
      );
      debugPrint('[MrWorkflow] Parse success for id=$id step=$step');
      return model;
    } catch (e, stackTrace) {
      debugPrint(
        '[MrWorkflow] Parse or network error for id=$id step=$step: $e',
      );
      debugPrint('[MrWorkflow] StackTrace: $stackTrace');
      return null;
    }
  }

  Future<void> forceClose(String id, String otp) async {
    final response = await _apiClient.post(
      '?c=MrWorkflow&m=forceClose',
      data: {
        'mr_request_id': id,
        'otp': otp,
      },
    );
    final jsonMap = response.data as Map<String, dynamic>;
    if (jsonMap['success'] != true) {
      throw Exception(
        jsonMap['message'] ?? 'API returned success=false for forceClose',
      );
    }
  }
}
