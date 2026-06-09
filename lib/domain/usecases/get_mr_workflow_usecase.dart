import '../../data/models/mr_workflow_response_model.dart';
import '../repositories/mr_workflow_repository.dart';

/// UseCase: lấy danh sách MR theo workflow step.
class GetMrWorkflowUseCase {
  final MrWorkflowRepository repository;

  GetMrWorkflowUseCase(this.repository);

  Future<MrWorkflowResponseModel> call({
    required String step,
    int page = 1,
  }) async {
    return repository.getByStep(step: step, page: page);
  }
}
