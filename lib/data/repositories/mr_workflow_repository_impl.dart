import '../../domain/repositories/mr_workflow_repository.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../../data/models/mr_workflow_response_model.dart';
import '../datasources/mr_workflow_remote_datasource.dart';

/// Repository implementation cho MR Workflow.
class MrWorkflowRepositoryImpl implements MrWorkflowRepository {
  final MrWorkflowRemoteDataSource remoteDataSource;

  MrWorkflowRepositoryImpl(this.remoteDataSource);

  @override
  Future<MrWorkflowResponseModel> getByStep({
    required String step,
    int page = 1,
  }) async {
    return remoteDataSource.getByStep(step: step, page: page);
  }

  @override
  Future<WorkflowReportEntity?> getReportDetail(String id, String step) async {
    return remoteDataSource.getReportDetail(id, step);
  }
}
