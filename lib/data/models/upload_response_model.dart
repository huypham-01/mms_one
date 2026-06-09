/// Response model cho Upload API.
/// Response structure:
/// {
///   "success": true,
///   "message": "Upload thành công",
///   "data": [
///     {
///       "file_name": "2ae7940c-b4f1-4d62-b505-aaeab36ece25.png",
///       "url": "/mms/uploads/xxx.png",
///       "path": "mms/uploads/xxx.png"
///     }
///   ]
/// }
class UploadFileModel {
  final String fileName;
  final String url;
  final String path;

  const UploadFileModel({
    required this.fileName,
    required this.url,
    required this.path,
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) {
    return UploadFileModel(
      fileName: json['file_name'] ?? '',
      url: json['url'] ?? '',
      path: json['path'] ?? '',
    );
  }
}

class UploadResponseModel {
  final bool success;
  final String message;
  final List<UploadFileModel> data;

  const UploadResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    return UploadResponseModel(
      success: json['success'] == true,
      message: json['message'] ?? '',
      data: rawList
          .map((e) => UploadFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Lấy path của file đầu tiên (dùng cho spec_picture)
  String? get firstPath => data.isNotEmpty ? data.first.path : null;
}
