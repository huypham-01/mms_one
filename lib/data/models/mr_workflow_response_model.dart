import 'mr_workflow_item_model.dart';

/// Model đại diện cho toàn bộ response từ API byStep.
/// Response structure:
/// {
///   "success": true,
///   "step": "preparer",
///   "data": {
///     "current_page": 1,
///     "data": [...],
///     "last_page": X,
///     "total": X,
///     "per_page": X
///   }
/// }
class MrWorkflowResponseModel {
  final bool success;
  final String step;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final List<MrWorkflowItemModel> data;

  const MrWorkflowResponseModel({
    required this.success,
    required this.step,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    required this.data,
  });

  factory MrWorkflowResponseModel.fromJson(Map<String, dynamic> json) {
    final pagination = json['data'] as Map<String, dynamic>? ?? {};
    final rawList = pagination['data'] as List<dynamic>? ?? [];

    return MrWorkflowResponseModel(
      success: json['success'] == true,
      step: json['step'] ?? '',
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
      perPage: pagination['per_page'] ?? 20,
      data: rawList
          .map((e) => MrWorkflowItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get hasNextPage => currentPage < lastPage;
}
