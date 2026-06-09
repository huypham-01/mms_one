import '../entities/workflow_report_entity.dart';
import '../repositories/mr_workflow_repository.dart';

class GetWorkflowReportDetailUseCase {
  final MrWorkflowRepository repository;

  GetWorkflowReportDetailUseCase(this.repository);

  Future<WorkflowReportEntity?> call(String id, String step) async {
    return repository.getReportDetail(id, step);
  }
}
