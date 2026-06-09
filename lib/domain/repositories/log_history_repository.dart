import '../entities/log_history_entity.dart';

abstract class LogHistoryRepository {
  Future<List<LogHistoryItemEntity>> getLogHistory(String mrId);
}
