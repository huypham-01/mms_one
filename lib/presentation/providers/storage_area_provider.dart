import 'package:flutter/material.dart';
import '../../domain/entities/storage_area_entity.dart';
import '../../domain/usecases/get_storage_areas_usecase.dart';

class StorageAreaProvider extends ChangeNotifier {
  final GetStorageAreasUseCase useCase;

  StorageAreaProvider(this.useCase);

  bool isLoading = false;
  String? error;
  
  List<StorageAreaGroupEntity> groups = [];
  
  int currentPage = 1;
  int lastPage = 1;
  bool hasMore = true;
  String? currentStatus;

  Future<void> loadStorageAreas({String? status}) async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    currentPage = 1;
    groups.clear();
    hasMore = true;
    if (status != null) {
      currentStatus = status == 'All' ? null : status;
    }
    notifyListeners();

    await _fetchData(page: currentPage);
  }

  Future<void> refresh() async {
    if (isLoading) return;
    isLoading = true;
    error = null;
    currentPage = 1;
    notifyListeners();

    await _fetchData(page: currentPage, isRefresh: true);
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();

    await _fetchData(page: currentPage + 1);
  }

  Future<void> _fetchData({required int page, bool isRefresh = false}) async {
    try {
      final response = await useCase.call(
        page: page,
        status: currentStatus,
      );
      
      currentPage = response.currentPage;
      lastPage = response.lastPage;
      hasMore = currentPage < lastPage;

      if (isRefresh || page == 1) {
        groups = response.groups;
      } else {
        groups.addAll(response.groups);
      }
      
      error = null;
    } catch (e) {
      error = _parseError(e);
      debugPrint('[StorageAreaProvider] Error: $e');
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
    if (msg.contains('HTTP 5')) {
      return 'Lỗi server. Vui lòng thử lại sau.';
    }
    return 'Failed to load storage area. $msg';
  }
}
