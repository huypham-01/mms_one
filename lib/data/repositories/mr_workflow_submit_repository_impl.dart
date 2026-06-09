import 'dart:io';

import '../../domain/repositories/mr_workflow_submit_repository.dart';
import '../../data/models/mr_workflow_submit_response_model.dart';
import '../../data/models/upload_response_model.dart';
import '../datasources/mr_workflow_reject_remote_datasource.dart';
import '../datasources/mr_workflow_submit_remote_datasource.dart';
import '../datasources/upload_remote_datasource.dart';

/// Repository implementation cho Upload & Workflow Submit.
class MrWorkflowSubmitRepositoryImpl implements MrWorkflowSubmitRepository {
  final UploadRemoteDataSource uploadDataSource;
  final MrWorkflowSubmitRemoteDataSource submitDataSource;
  final MrWorkflowRejectRemoteDataSource rejectDataSource;

  MrWorkflowSubmitRepositoryImpl({
    required this.uploadDataSource,
    required this.submitDataSource,
    required this.rejectDataSource,
  });

  @override
  Future<UploadResponseModel> uploadImage(File imageFile) {
    return uploadDataSource.uploadImage(imageFile);
  }

  @override
  Future<MrWorkflowSubmitResponseModel> submit({
    required String step,
    required String mrRequestId,
    required Map<String, dynamic> body,
  }) {
    return submitDataSource.submit(
      step: step,
      mrRequestId: mrRequestId,
      body: body,
    );
  }

  @override
  Future<MrWorkflowSubmitResponseModel> reject({required Map<String, dynamic> body}) {
    return rejectDataSource.reject(body: body);
  }
}
