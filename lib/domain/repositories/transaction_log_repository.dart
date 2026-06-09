import '../entities/transaction_log_entity.dart';

abstract class TransactionLogRepository {
  Future<List<TransactionLogItemEntity>> getTransactionLogs(String mrId);
}
