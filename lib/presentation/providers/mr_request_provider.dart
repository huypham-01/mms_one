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

  Future<void> fetchMrRequests({
    int page = 1,
    bool isRefresh = false,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await getMrRequestsUseCase.call(
        page: page,
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