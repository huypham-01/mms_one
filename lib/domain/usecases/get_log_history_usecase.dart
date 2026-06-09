import '../entities/log_history_entity.dart';
import '../repositories/log_history_repository.dart';

class GetLogHistoryUseCase {
  final LogHistoryRepository repository;

  GetLogHistoryUseCase(this.repository);

  Future<List<LogHistoryItemEntity>> call(String mrId) async {
    return repository.getLogHistory(mrId);
  }
}
