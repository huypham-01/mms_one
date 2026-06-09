import 'package:flutter/material.dart';
import '../../domain/entities/transaction_log_entity.dart';
import '../../domain/usecases/get_transaction_logs_usecase.dart';

class TransactionLogProvider extends ChangeNotifier {
  final GetTransactionLogsUseCase useCase;

  TransactionLogProvider(this.useCase);

  bool isLoading = false;
  String? error;
  List<TransactionLogItemEntity> logs = [];

  Future<void> loadLogs(String mrId) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    logs = [];
    notifyListeners();

    try {
      final data = await useCase.call(mrId);
      logs = data;
      error = null;
    } catch (e) {
      error = _parseError(e);
      debugPrint('[TransactionLogProvider] Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') || msg.contains('Network') || msg.contains('ClientException')) {
      return 'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.';
    }
    if (msg.contains('TimeoutException') || msg.contains('timed out')) {
      return 'Kết nối quá thời gian. Vui lòng thử lại.';
    }
    return 'Lỗi tải lịch sử giao dịch. $msg';
  }
}
