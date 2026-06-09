import 'package:flutter/material.dart';
import '../../domain/entities/log_history_entity.dart';
import '../../domain/usecases/get_log_history_usecase.dart';

enum LogHistoryStatus { idle, loading, loaded, error }

class LogHistoryProvider extends ChangeNotifier {
  final GetLogHistoryUseCase useCase;

  LogHistoryProvider(this.useCase);

  LogHistoryStatus _status = LogHistoryStatus.idle;
  List<LogHistoryItemEntity> _items = [];
  String? _errorMessage;

  // ── Public getters ────────────────────────────────────────────────────────
  LogHistoryStatus get status => _status;
  List<LogHistoryItemEntity> get items => _items;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == LogHistoryStatus.loading;
  bool get hasError => _status == LogHistoryStatus.error;
  bool get isEmpty =>
      _status == LogHistoryStatus.loaded && _items.isEmpty;

  // ── Load ─────────────────────────────────────────────────────────────────
  Future<void> load(String mrId) async {
    if (_status == LogHistoryStatus.loading) return;

    _status = LogHistoryStatus.loading;
    _errorMessage = null;
    _items = [];
    notifyListeners();

    try {
      _items = await useCase.call(mrId);
      _status = LogHistoryStatus.loaded;
    } catch (e) {
      _errorMessage = _parseError(e);
      _status = LogHistoryStatus.error;
      debugPrint('[LogHistoryProvider] Error: $e');
    }

    notifyListeners();
  }

  // ── Refresh ───────────────────────────────────────────────────────────────
  Future<void> refresh(String mrId) => load(mrId);

  // ── Private helpers ───────────────────────────────────────────────────────
  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') ||
        msg.contains('Network') ||
        msg.contains('ClientException')) {
      return 'Không có kết nối mạng. Vui lòng kiểm tra và thử lại.';
    }
    if (msg.contains('TimeoutException') || msg.contains('timed out')) {
      return 'Kết nối quá thời gian. Vui lòng thử lại.';
    }
    return 'Lỗi tải lịch sử. $msg';
  }
}
