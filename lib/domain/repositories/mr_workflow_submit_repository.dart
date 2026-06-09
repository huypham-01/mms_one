import 'dart:io';

import '../../data/models/mr_workflow_submit_response_model.dart';
import '../../data/models/upload_response_model.dart';

/// Abstract repository interface cho Upload & Workflow Submit.
abstract class MrWorkflowSubmitRepository {
  /// Upload một file ảnh lên server.
  Future<UploadResponseModel> uploadImage(File imageFile);

  /// Submit workflow theo step.
  Future<MrWorkflowSubmitResponseModel> submit({
    required String step,
    required String mrRequestId,
    required Map<String, dynamic> body,
  });
  Future<MrWorkflowSubmitResponseModel> reject({required Map<String, dynamic> body});
}
