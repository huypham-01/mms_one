import '../../core/mock/mock_mode_provider.dart';
import '../../domain/entities/log_history_entity.dart';
import '../../domain/repositories/log_history_repository.dart';
import '../datasources/log_history_remote_datasource.dart';
import '../mock/log_history/mock_log_history_datasource.dart';

class LogHistoryRepositoryImpl implements LogHistoryRepository {
  final LogHistoryRemoteDataSource remoteDataSource;
  final MockLogHistoryDataSource mockDataSource;
  final MockModeProvider mockModeProvider;

  LogHistoryRepositoryImpl(
    this.remoteDataSource,
    this.mockDataSource,
    this.mockModeProvider,
  );

  @override
  Future<List<LogHistoryItemEntity>> getLogHistory(String mrId) async {
    if (mockModeProvider.isMockMode) {
      return mockDataSource.getLogHistory(mrId);
    }
    return remoteDataSource.getLogHistory(mrId);
  }
}
