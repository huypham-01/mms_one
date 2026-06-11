import '../../core/mock/mock_mode_provider.dart';
import '../../domain/entities/transaction_log_entity.dart';
import '../../domain/repositories/transaction_log_repository.dart';
import '../datasources/transaction_log_remote_datasource.dart';
import '../mock/transaction_log/mock_transaction_log_datasource.dart';

class TransactionLogRepositoryImpl implements TransactionLogRepository {
  final TransactionLogRemoteDataSource remoteDataSource;
  final MockTransactionLogDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  TransactionLogRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<List<TransactionLogItemEntity>> getTransactionLogs(String mrId) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getTransactionLogs(mrId);
    }
    return remoteDataSource.getTransactionLogs(mrId);
  }
}
