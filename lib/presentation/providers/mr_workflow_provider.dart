import 'package:flutter/material.dart';

import '../../data/models/mr_workflow_item_model.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../../domain/usecases/get_mr_workflow_usecase.dart';
import '../../domain/usecases/get_workflow_report_detail_usecase.dart';

/// Provider quản lý state cho danh sách MR theo workflow step.
/// Mỗi workflow screen tạo 1 instance riêng với step tương ứng.
///
/// State machine:
///   idle → loading → loaded
///                 → error
///   loaded → loadingMore → loaded (append)
///          → refreshing  → loaded (replace)
class MrWorkflowProvider extends ChangeNotifier {
  final String step;
  final GetMrWorkflowUseCase useCase;
  final GetWorkflowReportDetailUseCase? detailUseCase;

  MrWorkflowProvider({
    required this.step,
    required this.useCase,
    this.detailUseCase,
  });

  // ── State ─────────────────────────────────────────────────────────────
  List<MrWorkflowItemModel> items = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isRefreshing = false;
  bool hasMoreData = true;
  String? errorMessage;

  // ── Detail State ────────────────────────────────────────────────────────
  WorkflowReportEntity? reportDetail;
  bool isDetailLoading = false;
  bool isDetailEmpty = false;
  String? detailError;

  int _currentPage = 1;
  int total = 0;

  bool get hasError => errorMessage != null;
  bool get isEmpty => !isLoading && items.isEmpty && !hasError;

  // ── Public API ─────────────────────────────────────────────────────────

  /// Fetch trang đầu tiên (gọi 1 lần khi init screen).
  Future<void> fetch() async {
    if (isLoading) return;
    _reset();
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await _doFetch(page: 1, append: false);
  }

  /// Kéo xuống cuối để load thêm trang kế tiếp.
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMoreData || isLoading) return;
    isLoadingMore = true;
    notifyListeners();

    await _doFetch(page: _currentPage + 1, append: true);
  }

  /// Pull-to-refresh: tải lại từ đầu.
  Future<void> refresh() async {
    if (isRefreshing) return;
    _reset();
    isRefreshing = true;
    errorMessage = null;
    notifyListeners();

    await _doFetch(page: 1, append: false);
  }

  /// Load detail for a specific report
  Future<void> loadReportDetail(String id, String step) async {
    if (detailUseCase == null) return;
    
    isDetailLoading = true;
    detailError = null;
    isDetailEmpty = false;
    notifyListeners();

    try {
      reportDetail = await detailUseCase!(id, step);
      if (reportDetail == null) {
        isDetailEmpty = true;
      }
    } catch (e) {
      detailError = _parseError(e);
      debugPrint('[MrWorkflowProvider] Error loading detail id=$id: $e');
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  // ── Private ────────────────────────────────────────────────────────────

  void _reset() {
    _currentPage = 1;
    hasMoreData = true;
    items = [];
  }

  Future<void> _doFetch({required int page, required bool append}) async {
    try {
      final response = await useCase.call(step: step, page: page);

      _currentPage = response.currentPage;
      total = response.total;
      hasMoreData = response.hasNextPage;

      if (append) {
        items = [...items, ...response.data];
      } else {
        items = response.data;
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = _parseError(e);
      debugPrint('[MrWorkflowProvider] Error step=$step page=$page: $e');
    } finally {
      isLoading = false;
      isLoadingMore = false;
      isRefreshing = false;
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
    if (msg.contains('HTTP 5')) {
      return 'Lỗi server. Vui lòng thử lại sau.';
    }
    return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }
}
