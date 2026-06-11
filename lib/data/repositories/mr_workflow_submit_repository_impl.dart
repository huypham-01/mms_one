import 'dart:io';

import '../../core/mock/mock_mode_provider.dart';
import '../../domain/repositories/mr_workflow_submit_repository.dart';
import '../../data/models/mr_workflow_submit_response_model.dart';
import '../../data/models/upload_response_model.dart';
import '../datasources/mr_workflow_reject_remote_datasource.dart';
import '../datasources/mr_workflow_submit_remote_datasource.dart';
import '../datasources/upload_remote_datasource.dart';
import '../mock/workflow/mock_mr_workflow_submit_datasource.dart';

/// Repository implementation cho Upload & Workflow Submit.
class MrWorkflowSubmitRepositoryImpl implements MrWorkflowSubmitRepository {
  final UploadRemoteDataSource uploadDataSource;
  final MrWorkflowSubmitRemoteDataSource submitDataSource;
  final MrWorkflowRejectRemoteDataSource rejectDataSource;
  final MockMrWorkflowSubmitDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  MrWorkflowSubmitRepositoryImpl({
    required this.uploadDataSource,
    required this.submitDataSource,
    required this.rejectDataSource,
    required this.mockDataSource,
    required this.mockModeProvider,
  });

  @override
  Future<UploadResponseModel> uploadImage(File imageFile) {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.uploadImage(imageFile);
    }
    return uploadDataSource.uploadImage(imageFile);
  }

  @override
  Future<MrWorkflowSubmitResponseModel> submit({
    required String step,
    required String mrRequestId,
    required Map<String, dynamic> body,
  }) {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.submit(
        step: step,
        mrRequestId: mrRequestId,
        body: body,
      );
    }
    return submitDataSource.submit(
      step: step,
      mrRequestId: mrRequestId,
      body: body,
    );
  }

  @override
  Future<MrWorkflowSubmitResponseModel> reject({
    required Map<String, dynamic> body,
  }) {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.reject(body: body);
    }
    return rejectDataSource.reject(body: body);
  }
}
