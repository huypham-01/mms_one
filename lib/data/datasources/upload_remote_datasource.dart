import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../core/network/api_client.dart';
import '../models/upload_response_model.dart';

/// Remote data source cho Upload API.
/// Endpoint: POST ?c=Upload&m=store
class UploadRemoteDataSource {
  final ApiClient _apiClient;
  static const _maxFileSizeKb = 500; // KB

  UploadRemoteDataSource(this._apiClient);

  /// Nén ảnh về dưới [_maxFileSizeKb]KB rồi upload lên server.
  Future<UploadResponseModel> uploadImage(File imageFile) async {
    debugPrint('[Upload] Original: ${imageFile.path}');

    // --- Compress ảnh ---
    final compressed = await _compressImage(imageFile);
    debugPrint(
      '[Upload] Compressed size: ${(compressed.length / 1024).toStringAsFixed(1)} KB',
    );

    // --- Lấy tên file ---
    final fileName = imageFile.path.split('/').last.split('\\').last;

    // --- Tạo FormData cho Dio ---
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        compressed,
        filename: fileName,
      ),
    });

    // --- Gửi Request ---
    final response = await _apiClient.post(
      '?c=Upload&m=store',
      data: formData,
    );

    final jsonMap = response.data as Map<String, dynamic>;
    final model = UploadResponseModel.fromJson(jsonMap);
    
    if (!model.success) {
      throw Exception(
        'Upload API returned success=false: ${model.message}',
      );
    }
    
    debugPrint('[Upload] Success: ${model.firstPath}');
    return model;
  }

  /// Nén ảnh xuống dưới [_maxFileSizeKb]KB.
  Future<Uint8List> _compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final originalKb = bytes.length / 1024;

    if (originalKb <= _maxFileSizeKb) {
      return bytes;
    }

    int quality = ((_maxFileSizeKb / originalKb) * 85).clamp(30, 85).round();

    for (int attempt = 0; attempt < 3; attempt++) {
      final result = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      final resultKb = result.length / 1024;

      if (resultKb <= _maxFileSizeKb) return result;

      quality = (quality * 0.7).round().clamp(20, quality - 1);
    }

    return FlutterImageCompress.compressWithList(
      bytes,
      quality: 20,
      format: CompressFormat.jpeg,
    );
  }
}
