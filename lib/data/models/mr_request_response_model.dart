import 'mr_request_model.dart';

class MrRequestResponseModel {
  final int currentPage;
  final int lastPage;
  final int total;
  final List<MrRequestModel> data;

  MrRequestResponseModel({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.data,
  });

  factory MrRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return MrRequestResponseModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
      data: (json['data'] as List)
          .map((e) => MrRequestModel.fromJson(e))
          .toList(),
    );
  }
}