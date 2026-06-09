import 'package:flutter/material.dart';
import '../../domain/entities/overtime_entity.dart';
import '../../domain/usecases/get_overtimes_usecase.dart';

class OvertimeProvider extends ChangeNotifier {
  final GetOvertimesUseCase useCase;

  OvertimeProvider(this.useCase);

  bool isLoading = false;
  String? error;

  List<OvertimeMrEntity> items = [];
  int currentPage = 1;
  int lastPage = 1;
  int total = 0;
  bool get hasMore => currentPage < lastPage;

  Future<void> loadOvertimes() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    currentPage = 1;
    items.clear();
    notifyListeners();

    await _fetch(page: 1);
  }

  Future<void> refresh() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    currentPage = 1;
    notifyListeners();

    await _fetch(page: 1, isRefresh: true);
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    await _fetch(page: currentPage + 1);
  }

  Future<void> _fetch({required int page, bool isRefresh = false}) async {
    try {
      final result = await useCase.call(page: page);

      currentPage = result.currentPage;
      lastPage = result.lastPage;
      total = result.total;

      if (isRefresh || page == 1) {
        items = result.items;
      } else {
        items = [...items, ...result.items];
      }

      error = null;
    } catch (e) {
      error = _parseError(e);
      debugPrint('[OvertimeProvider] Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
    return 'Lỗi tải dữ liệu overtime. $msg';
  }
}
