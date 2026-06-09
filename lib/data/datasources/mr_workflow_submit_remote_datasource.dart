import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../models/mr_workflow_submit_response_model.dart';

/// Remote data source cho MR Workflow Submit API.
/// Endpoints:
///   POST ?c=MrWorkflow&m={step}&mr_request_id={id}&stepName={step}
class MrWorkflowSubmitRemoteDataSource {
  final ApiClient _apiClient;

  MrWorkflowSubmitRemoteDataSource(this._apiClient);

  /// Submit workflow theo step.
  Future<MrWorkflowSubmitResponseModel> submit({
    required String step,
    required String mrRequestId,
    required Map<String, dynamic> body,
  }) async {
    debugPrint('[MrWorkflowSubmit] POST step=$step id=$mrRequestId');

    final response = await _apiClient.post(
      '?c=MrWorkflow&m=$step&mr_request_id=$mrRequestId&stepName=$step',
      data: body,
    );

    final jsonMap = response.data as Map<String, dynamic>;
    return MrWorkflowSubmitResponseModel.fromJson(jsonMap);
  }
}
