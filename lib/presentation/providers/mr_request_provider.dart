import 'package:flutter/material.dart';

import '../../data/models/mr_request_model.dart';
import '../../domain/usecases/get_mr_requests_usecase.dart';

class MrRequestProvider extends ChangeNotifier {
  final GetMrRequestsUseCase getMrRequestsUseCase;

  MrRequestProvider(this.getMrRequestsUseCase);

  bool isLoading = false;

  List<MrRequestModel> requests = [];

  int currentPage = 1;
  int lastPage = 1;
  int total = 0;

  // ── Date filter state ────────────────────────────────────────────────
  String? filterDate;
  String? filterDateFrom;
  String? filterDateTo;

  /// Apply a single-date filter and reload from page 1.
  Future<void> applyDateFilter({
    String? date,
    String? dateFrom,
    String? dateTo,
  }) async {
    filterDate = date;
    filterDateFrom = dateFrom;
    filterDateTo = dateTo;
    await fetchMrRequests(page: 1, isRefresh: true);
  }

  /// Clear all date filters and reload.
  Future<void> clearDateFilter() async {
    filterDate = null;
    filterDateFrom = null;
    filterDateTo = null;
    await fetchMrRequests(page: 1, isRefresh: true);
  }

  Future<void> fetchMrRequests({
    int page = 1,
    bool isRefresh = false,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await getMrRequestsUseCase.call(
        page: page,
        date: filterDate,
        dateFrom: filterDateFrom,
        dateTo: filterDateTo,
      );

      currentPage = response.currentPage;
      lastPage = response.lastPage;
      total = response.total;

      if (isRefresh || page == 1) {
        requests = response.data;
      } else {
        requests.addAll(response.data);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (currentPage < lastPage && !isLoading) {
      await fetchMrRequests(
        page: currentPage + 1,
      );
    }
  }

  Future<void> refresh() async {
    await fetchMrRequests(
      page: 1,
      isRefresh: true,
    );
  }
}