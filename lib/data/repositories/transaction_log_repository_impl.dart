import '../../domain/entities/transaction_log_entity.dart';
import '../../domain/repositories/transaction_log_repository.dart';
import '../datasources/transaction_log_remote_datasource.dart';

class TransactionLogRepositoryImpl implements TransactionLogRepository {
  final TransactionLogRemoteDataSource remoteDataSource;

  TransactionLogRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TransactionLogItemEntity>> getTransactionLogs(String mrId) async {
    return remoteDataSource.getTransactionLogs(mrId);
  }
}
