import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/mr_workflow_submit_response_model.dart';

/// Remote data source cho MR Workflow Submit API.
class MrWorkflowRejectRemoteDataSource {
  final ApiClient _apiClient;

  MrWorkflowRejectRemoteDataSource(this._apiClient);

  /// Reject workflow theo step.
  Future<MrWorkflowSubmitResponseModel> reject({
    required Map<String, dynamic> body,
  }) async {
    debugPrint('[MrWorkflowReject] POST MrWorkflow&m=reject');

    final response = await _apiClient.post(
      '?c=MrWorkflow&m=reject',
      data: body,
    );

    final jsonMap = response.data as Map<String, dynamic>;
    return MrWorkflowSubmitResponseModel.fromJson(jsonMap);
  }
}
