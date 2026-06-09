/// Model submit response từ MrWorkflow API.
/// Response structure:
/// {
///   "success": true/false,
///   "message": "...",
///   "data": { ... } (optional)
/// }
class MrWorkflowSubmitResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  const MrWorkflowSubmitResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory MrWorkflowSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return MrWorkflowSubmitResponseModel(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
