import '../../domain/repositories/mr_workflow_repository.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../../data/models/mr_workflow_response_model.dart';
import '../datasources/mr_workflow_remote_datasource.dart';
import '../mock/workflow/mock_mr_workflow_datasource.dart';
import '../../core/mock/mock_mode_provider.dart';

/// Repository implementation cho MR Workflow.
class MrWorkflowRepositoryImpl implements MrWorkflowRepository {
  final MrWorkflowRemoteDataSource remoteDataSource;
  final MockMrWorkflowDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  MrWorkflowRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<MrWorkflowResponseModel> getByStep({
    required String step,
    int page = 1,
  }) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getByStep(step: step, page: page);
    }
    return remoteDataSource.getByStep(step: step, page: page);
  }

  @override
  Future<WorkflowReportEntity?> getReportDetail(String id, String step) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getReportDetail(id, step);
    }
    return remoteDataSource.getReportDetail(id, step);
  }

  @override
  Future<void> forceClose(String id, String otp) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.forceClose(id, otp);
    }
    return remoteDataSource.forceClose(id, otp);
  }
}
