import '../../data/models/mr_workflow_response_model.dart';
import '../entities/workflow_report_entity.dart';

/// Abstract repository interface cho MR Workflow.
abstract class MrWorkflowRepository {
  Future<MrWorkflowResponseModel> getByStep({
    required String step,
    int page = 1,
  });

  Future<WorkflowReportEntity?> getReportDetail(String id, String step);

  Future<void> forceClose(String id, String otp);
}
