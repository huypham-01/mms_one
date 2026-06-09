import '../../domain/entities/log_history_entity.dart';
import '../../domain/repositories/log_history_repository.dart';
import '../datasources/log_history_remote_datasource.dart';

class LogHistoryRepositoryImpl implements LogHistoryRepository {
  final LogHistoryRemoteDataSource remoteDataSource;

  LogHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<LogHistoryItemEntity>> getLogHistory(String mrId) async {
    return remoteDataSource.getLogHistory(mrId);
  }
}
