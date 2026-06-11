import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../data/models/mr_workflow_submit_response_model.dart';
import '../../../data/models/upload_response_model.dart';

class MockMrWorkflowSubmitDataSource {
  Future<UploadResponseModel> uploadImage(File imageFile) async {
    debugPrint('[Mock] Mock upload image: ${imageFile.path}');
    await Future.delayed(const Duration(milliseconds: 300));

    final fileName = imageFile.path.split('/').last.split('\\').last;
    return UploadResponseModel(
      success: true,
      message: 'Mock upload success',
      data: [
        UploadFileModel(
          fileName: fileName,
          url: '/mms/uploads/mock/$fileName',
          path: 'mms/uploads/mock/$fileName',
        ),
      ],
    );
  }

  Future<MrWorkflowSubmitResponseModel> submit({
    required String step,
    required String mrRequestId,
    required Map<String, dynamic> body,
  }) async {
    debugPrint(
      '[Mock] Mock submit workflow step=$step id=$mrRequestId body=$body',
    );
    await Future.delayed(const Duration(milliseconds: 500));

    return MrWorkflowSubmitResponseModel(
      success: true,
      message: 'Mock submit success',
      data: {
        'mr_request_id': mrRequestId,
        'step': step,
        'submitted_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<MrWorkflowSubmitResponseModel> reject({
    required Map<String, dynamic> body,
  }) async {
    debugPrint('[Mock] Mock reject workflow body=$body');
    await Future.delayed(const Duration(milliseconds: 500));

    return MrWorkflowSubmitResponseModel(
      success: true,
      message: 'Mock reject success',
      data: {
        'mr_request_id': body['mr_request_id'],
        'step': body['step'],
        'rejected_at': DateTime.now().toIso8601String(),
      },
    );
  }
}
