import '../entities/transaction_log_entity.dart';
import '../repositories/transaction_log_repository.dart';

class GetTransactionLogsUseCase {
  final TransactionLogRepository repository;

  GetTransactionLogsUseCase(this.repository);

  Future<List<TransactionLogItemEntity>> call(String mrId) async {
    return repository.getTransactionLogs(mrId);
  }
}
