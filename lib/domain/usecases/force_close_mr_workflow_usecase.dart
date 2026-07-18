import '../repositories/mr_workflow_repository.dart';

class ForceCloseMrWorkflowUseCase {
  final MrWorkflowRepository repository;

  ForceCloseMrWorkflowUseCase(this.repository);

  Future<void> call(String id, String otp) {
    return repository.forceClose(id, otp);
  }
}
