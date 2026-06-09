import 'dart:io';
import 'package:flutter/material.dart';
import '../models/workflow_item_model.dart';
import '../services/workflow_service.dart';

enum WorkflowStep {
  preparer,
  warehouse,
  receiver,
  lineLeader,
  production;

  String get key {
    switch (this) {
      case WorkflowStep.preparer: return 'preparer';
      case WorkflowStep.warehouse: return 'warehouse';
      case WorkflowStep.receiver: return 'receiver';
      case WorkflowStep.lineLeader: return 'line_leader';
      case WorkflowStep.production: return 'production';
    }
  }

  String get submitEndpoint {
    switch (this) {
      case WorkflowStep.preparer: return '/mr-requests/preparer/submit';
      case WorkflowStep.warehouse: return '/mr-requests/warehouse/submit';
      case WorkflowStep.receiver: return '/mr-requests/receiver/submit';
      case WorkflowStep.lineLeader: return '/mr-requests/line-leader/submit';
      case WorkflowStep.production: return '/mr-requests/production/submit';
    }
  }

  String get label {
    switch (this) {
      case WorkflowStep.preparer: return 'Preparer';
      case WorkflowStep.warehouse: return 'Warehouse';
      case WorkflowStep.receiver: return 'Receiver';
      case WorkflowStep.lineLeader: return 'Line Leader';
      case WorkflowStep.production: return 'Production';
    }
  }
}

class WorkflowController extends ChangeNotifier {
  final WorkflowService _service;

  WorkflowController(this._service);

  List<WorkflowItemModel> _items = [];
  List<WorkflowItemModel> get items => _items;

  WorkflowItemModel? _selectedMR;
  WorkflowItemModel? get selectedMR => _selectedMR;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void selectMR(WorkflowItemModel? item) {
    _selectedMR = item;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Lấy danh sách Material Requests theo Step hiện tại
  Future<void> fetchWorkflowItems(WorkflowStep step) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _items = await _service.fetchWorkflowItems(step.key);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validate toàn bộ form dữ liệu động theo Step hiện tại
  String? validateForm({
    required WorkflowStep step,
    required Map<String, dynamic> rawInput,
    required bool hasPhotos,
  }) {
    final verificationMethod = _selectedMR?.verificationMethod?.toLowerCase();

    // 1. Validate theo phương thức xác thực của Material Request
    if (verificationMethod == 'picture' && !hasPhotos) {
      return 'Verification method là Picture — vui lòng chụp ít nhất 1 ảnh.';
    }

    if (verificationMethod == 'scan') {
      final barcode = rawInput['barcode_scan']?.toString().trim();
      if (barcode == null || barcode.isEmpty) {
        return 'Vui lòng scan barcode trước khi submit.';
      }
      final verificationCode = _selectedMR?.verificationCode?.trim();
      if (barcode != verificationCode) {
        return 'Barcode không khớp với Verification Code.';
      }
    }

    // 2. Validate theo từng Step nghiệp vụ cụ thể
    switch (step) {
      case WorkflowStep.preparer:
        final lots = rawInput['lots'] as List?;
        if (lots == null || lots.isEmpty) {
          return 'Vui lòng nhập thông tin Lot.';
        }
        for (int i = 0; i < lots.length; i++) {
          final lot = lots[i];
          final name = lot['lot_name']?.toString().trim() ?? '';
          final qtyStr = lot['qty']?.toString().trim() ?? '';
          if (name.isEmpty) {
            return 'Vui lòng nhập tên Lot thứ ${i + 1}.';
          }
          final qty = double.tryParse(qtyStr);
          if (qty == null || qty <= 0) {
            return 'Số lượng Lot thứ ${i + 1} không hợp lệ.';
          }
        }
        if (rawInput['locker']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng scan Locker.';
        }
        break;

      case WorkflowStep.warehouse:
        if (rawInput['warehouse_locker']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng scan Warehouse Locker.';
        }
        break;

      case WorkflowStep.receiver:
        if (rawInput['production_locker']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng scan Production Locker.';
        }
        if (rawInput['received_by']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập Received By.';
        }
        if (rawInput['mr_name']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập MR Name.';
        }
        break;

      case WorkflowStep.lineLeader:
        if (rawInput['production_locker']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng scan Production Locker.';
        }
        if (rawInput['receiver_from']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập Receiver From.';
        }
        if (rawInput['leader_name']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập Leader Name.';
        }
        break;

      case WorkflowStep.production:
        final qtyStr = rawInput['qty_to_production']?.toString().trim() ?? '';
        final qty = double.tryParse(qtyStr);
        if (qty == null || qty <= 0) {
          return 'Quantity to Production phải là số dương.';
        }
        if (rawInput['to_where']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập To Where.';
        }
        if (rawInput['to_who']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập To Who.';
        }
        if (rawInput['from_locker']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng scan From Locker.';
        }
        if (rawInput['from_leader']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập From Leader.';
        }
        if (rawInput['from_name']?.toString().trim().isEmpty ?? true) {
          return 'Vui lòng nhập From Name.';
        }
        break;
    }

    return null; // Hợp lệ
  }

  /// Submit và xử lý build payload động theo step nghiệp vụ
  Future<bool> submitWorkflow({
    required WorkflowStep step,
    required Map<String, dynamic> rawInput,
    required String otp,
    File? photoFile,
  }) async {
    if (_selectedMR == null) {
      _errorMessage = 'Vui lòng chọn Material Request trước khi submit.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Xử lý upload ảnh nếu có file được chọn
      String? uploadedPicture;
      if (photoFile != null) {
        uploadedPicture = await _service.uploadImage(photoFile);
        if (uploadedPicture != null) {
          uploadedPicture = '["$uploadedPicture"]';
        }
      }

      // 2. Lấy dữ liệu chung
      final verificationMethod = _selectedMR?.verificationMethod ?? '';
      final verificationCode = _selectedMR?.verificationCode ?? '';
      final barcodeScan = rawInput['barcode_scan']?.toString().trim() ?? '';
      final isScanCorrect = barcodeScan == verificationCode;

      // 3. Build payload tương ứng với từng Step
      final Map<String, dynamic> payload = {
        'otp': otp,
        'spec_check': rawInput['spec_check'] ?? false,
        'quantity_check': rawInput['quantity_check'] ?? false,
        'verify_method': verificationMethod,
        'verification_code': verificationCode,
        'barcode_scan': barcodeScan,
        'spec_picture': uploadedPicture,
      };

      switch (step) {
        case WorkflowStep.preparer:
          payload['locker'] = rawInput['locker'];
          payload['person_name'] = '';
          payload['extra_data'] = {
            'lots': rawInput['lots'],
            'prepared_quantity': rawInput['prepared_quantity'],
            'difference': rawInput['difference'],
            'scan_result': isScanCorrect ? 'Correct' : 'Wrong',
          };
          break;

        case WorkflowStep.warehouse:
          payload['locker'] = rawInput['warehouse_locker'];
          payload['extra_data'] = {
            'difference': rawInput['difference'],
            'scan_result': isScanCorrect ? 'Correct' : 'Wrong',
          };
          break;

        case WorkflowStep.receiver:
          payload['locker'] = rawInput['production_locker'];
          payload['person_name'] = rawInput['received_by'];
          payload['extra_data'] = {
            'mr_name': rawInput['mr_name'],
            'scan_result': isScanCorrect ? 'Correct' : 'Wrong',
          };
          break;

        case WorkflowStep.lineLeader:
          payload['locker'] = rawInput['production_locker'];
          payload['person_name'] = rawInput['leader_name'];
          payload['extra_data'] = {
            'received_from': rawInput['receiver_from'],
            'scan_result': isScanCorrect ? 'Correct' : 'Wrong',
          };
          break;

        case WorkflowStep.production:
          payload['locker'] = rawInput['from_locker'];
          payload['person_name'] = rawInput['from_name'];
          payload['extra_data'] = {
            'to_where': rawInput['to_where'],
            'to_who': rawInput['to_who'],
            'to_production_now': rawInput['qty_to_production'],
            'from_leader': rawInput['from_leader'],
            'scan_result': isScanCorrect ? 'Correct' : 'Wrong',
          };
          break;
      }

      await _service.submit(endpoint: step.submitEndpoint, body: payload);
      _selectedMR = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Gửi lệnh từ chối (Reject) bước workflow hiện tại
  Future<bool> rejectWorkflow({
    required WorkflowStep step,
    required String reason,
    required String otp,
  }) async {
    if (_selectedMR == null) {
      _errorMessage = 'Không tìm thấy Material Request để từ chối.';
      notifyListeners();
      return false;
    }

    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.reject(
        step: step.key,
        mrRequestId: _selectedMR!.id,
        reason: reason,
        otp: otp,
      );
      _selectedMR = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
