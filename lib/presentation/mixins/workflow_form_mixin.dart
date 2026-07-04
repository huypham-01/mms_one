import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/localization_extensions.dart';
import '../../data/models/mr_workflow_item_model.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../../domain/repositories/mr_workflow_submit_repository.dart';
import '../components/workflow_components.dart';
import '../providers/mr_workflow_provider.dart';
import '../widgets/modern_scanner_screen.dart';
import '../widgets/otp_dialog.dart';
import '../widgets/otp_reject_dialog.dart';
import '../widgets/photo_picker_widget.dart';

// ---------------------------------------------------------------------------
// Lot Data (không liên quan API, giữ nguyên)
// ---------------------------------------------------------------------------
class LotData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
  }
}

// ---------------------------------------------------------------------------
// MIXIN
// ---------------------------------------------------------------------------
mixin WorkflowFormMixin<T extends StatefulWidget> on State<T> {
  // --- Lot Information ---
  final List<LotData> lots = [LotData()];

  // --- Verification ---
  bool specCheck = false;
  bool quantityCheck = false;
  final String locker = '-';
  final String preparerId = '-';

  // --- Preparer Info ---
  late String prepareDate;

  // Selected Material Request (real API data)
  MrWorkflowItemModel? selectedMR;

  // --- Photo picker controller (dùng để đọc danh sách ảnh khi submit) ---
  final PhotoPickerController photoPickerController = PhotoPickerController();

  // --- Submit state ---
  bool isSubmitting = false;

  bool get isPictureVerification =>
      selectedMR?.verificationMethod?.toLowerCase() == 'picture';

  bool get isScanVerification =>
      selectedMR?.verificationMethod?.toLowerCase() == 'scan';

  // ── Read-only controllers (populated when MR is selected) ──────────────────
  final TextEditingController requestNumberCtrl = TextEditingController();
  final TextEditingController workOrderCtrl = TextEditingController();
  final TextEditingController demandWkCtrl = TextEditingController();
  final TextEditingController pcnCtrl = TextEditingController();
  final TextEditingController finishGoodCtnCtrl = TextEditingController();
  final TextEditingController materialPnCtrl = TextEditingController();
  final TextEditingController materialNameCtrl = TextEditingController();
  final TextEditingController requestQtyCtrl = TextEditingController();
  final TextEditingController requestUnitCtrl = TextEditingController();

  // ── Verification / common controllers ─────────────────────────────────────
  final TextEditingController preparedQuantityCtrl = TextEditingController();
  final TextEditingController differenceCtrl = TextEditingController();
  final TextEditingController verifyMethodCtrl = TextEditingController();
  final TextEditingController verificationCodeCtrl = TextEditingController();
  final TextEditingController barcodeCtrl = TextEditingController();
  final TextEditingController scanResultCtrl = TextEditingController();
  final TextEditingController lockerCtrl = TextEditingController();
  final TextEditingController scanPcnCtrl = TextEditingController();
  final TextEditingController scanResultPcnCtrl = TextEditingController();
  final TextEditingController scanPnCtrl = TextEditingController();
  final TextEditingController scanResultPnCtrl = TextEditingController();
  final TextEditingController preparerNameCtrl = TextEditingController();

  // ── Warehouse ──────────────────────────────────────────────────────────────
  final TextEditingController warehouseLockerCtrl = TextEditingController();

  // ── Receiver ──────────────────────────────────────────────────────────────
  final TextEditingController productionLockerCtrl = TextEditingController();
  final TextEditingController warehouseKeeperCtrl = TextEditingController();
  // final TextEditingController mrNameCtrl = TextEditingController();

  // ── Line Leader ────────────────────────────────────────────────────────────
  final TextEditingController receiverFromCtrl = TextEditingController();
  final TextEditingController leaderNameCtrl = TextEditingController();

  // ── Production ─────────────────────────────────────────────────────────────
  final TextEditingController quantityToProductionCtrl =
      TextEditingController();
  final TextEditingController toWhereCtrl = TextEditingController();
  final TextEditingController toWhoCtrl = TextEditingController();
  final TextEditingController fromLockerCtrl = TextEditingController();
  final TextEditingController fromLeaderCtrl = TextEditingController();
  final TextEditingController fromNameCtrl = TextEditingController();

  /// Subclass phải override để cung cấp step cho API.
  /// Giá trị hợp lệ: 'preparer' | 'warehouse' | 'receiver' | 'line_leader' | 'production'
  String get workflowStep;

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Chỉ hiển thị buildLotInformationCard với preparer và warehouse
  bool get _showLotInformation =>
      workflowStep == 'preparer' || workflowStep == 'warehouse';

  @override
  void initState() {
    super.initState();
    prepareDate = formattedNow();
    lots.first.qtyController.addListener(updatePreparedQuantity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkflowData();
    });
  }

  void _fetchWorkflowData() {
    final provider = context.read<MrWorkflowProvider>();
    if (provider.step == workflowStep && provider.items.isEmpty) {
      provider.fetch();
    }
  }

  String formattedNow() {
    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
    final time =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  void updatePreparedQuantity() {
    double total = 0;
    for (final lot in lots) {
      final qty = double.tryParse(lot.qtyController.text.trim()) ?? 0;
      total += qty;
    }
    preparedQuantityCtrl.text = total % 1 == 0
        ? total.toInt().toString()
        : total.toStringAsFixed(2);
    // cập nhật Difference
    differenceCtrl.text = _calculateDifference();
  }

  void onMRSelected(MrWorkflowItemModel item) {
    setState(() {
      selectedMR = item;
      requestNumberCtrl.text = item.requestNumber;
      workOrderCtrl.text = item.workOrder;
      demandWkCtrl.text = item.demandWk;
      pcnCtrl.text = item.pcn;
      finishGoodCtnCtrl.text = item.finishGoodCtn;
      materialPnCtrl.text = item.materialPn;
      materialNameCtrl.text = item.materialName;
      requestQtyCtrl.text = '${item.requestQuantity} ${item.unit}';
      requestUnitCtrl.text = item.unit;

      if (item.verificationMethod != null) {
        verifyMethodCtrl.text = item.verificationMethod ?? '';
      }
      if (item.verificationCode != null) {
        verificationCodeCtrl.text = item.verificationCode ?? '';
      }
      if (item.locker != null) {
        lockerCtrl.text = item.locker!;
      }
    });
    Navigator.pop(context);

    // Với step warehouse: load detail để fill lots & difference
    if (workflowStep == 'warehouse') {
      context
          .read<MrWorkflowProvider>()
          .loadReportDetail(item.id, 'preparer')
          .then((_) {
            if (!mounted) return;
            final report = context.read<MrWorkflowProvider>().reportDetail;
            if (report != null) _applyWarehouseReportDetail(report);
          });
    }
  }

  /// Fill lots và difference từ report detail — chỉ dùng cho step warehouse.
  void _applyWarehouseReportDetail(WorkflowReportEntity report) {
    setState(() {
      // ── Lots ────────────────────────────────────────────────────────────
      for (final lot in lots) {
        lot.qtyController.removeListener(updatePreparedQuantity);
        lot.dispose();
      }
      lots.clear();

      for (final LotInformationEntity lotEntity in report.lots) {
        final ld = LotData();
        ld.nameController.text = lotEntity.lotName;
        ld.qtyController.text = lotEntity.quantity.toString();
        ld.qtyController.addListener(updatePreparedQuantity);
        lots.add(ld);
      }

      // Đảm bảo luôn có ít nhất 1 lot
      if (lots.isEmpty) {
        final ld = LotData();
        ld.qtyController.addListener(updatePreparedQuantity);
        lots.add(ld);
      }

      // ── Difference ──────────────────────────────────────────────────────
      differenceCtrl.text = report.difference.toString();

      // Cập nhật lại preparedQuantity từ lot qty controllers
      updatePreparedQuantity();
    });
  }

  @override
  void dispose() {
    for (var lot in lots) {
      lot.dispose();
    }
    photoPickerController.dispose();
    // Material Request
    requestNumberCtrl.dispose();
    workOrderCtrl.dispose();
    demandWkCtrl.dispose();
    pcnCtrl.dispose();
    finishGoodCtnCtrl.dispose();
    materialPnCtrl.dispose();
    materialNameCtrl.dispose();
    requestQtyCtrl.dispose();
    requestUnitCtrl.dispose();
    // Common verification
    preparedQuantityCtrl.dispose();
    differenceCtrl.dispose();
    verifyMethodCtrl.dispose();
    verificationCodeCtrl.dispose();
    barcodeCtrl.dispose();
    scanResultCtrl.dispose();
    lockerCtrl.dispose();
    scanPcnCtrl.dispose();
    scanResultPcnCtrl.dispose();
    scanPnCtrl.dispose();
    scanResultPnCtrl.dispose();
    preparerNameCtrl.dispose();
    // Warehouse
    warehouseLockerCtrl.dispose();
    // Receiver
    productionLockerCtrl.dispose();
    warehouseKeeperCtrl.dispose();
    // mrNameCtrl.dispose();
    // Line Leader
    receiverFromCtrl.dispose();
    leaderNameCtrl.dispose();
    // Production
    quantityToProductionCtrl.dispose();
    toWhereCtrl.dispose();
    toWhoCtrl.dispose();
    fromLockerCtrl.dispose();
    fromLeaderCtrl.dispose();
    fromNameCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SCAN HELPERS (dùng chung tránh lặp code)
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _scanBarcode(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ModernScannerScreen(title: context.l10n.scanBarcode),
      ),
    );
    if (!mounted || code == null) return;
    setState(() {
      barcodeCtrl.text = code;

      final barcode = code.trim();
      final verification = verificationCodeCtrl.text.trim();

      scanResultCtrl.text = barcode == verification
          ? context.l10n.correct
          : context.l10n.wrong;
    });
  }

  Future<void> _scanPCN(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ModernScannerScreen(title: context.l10n.scanBarcode),
      ),
    );
    if (!mounted || code == null) return;
    setState(() {
      scanPcnCtrl.text = code;

      final barcode = code.trim();
      final verification = pcnCtrl.text.trim();

      scanResultPcnCtrl.text = barcode == verification
          ? context.l10n.correct
          : context.l10n.wrong;
    });
  }

  Future<void> _scanPN(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ModernScannerScreen(title: context.l10n.scanBarcode),
      ),
    );
    if (!mounted || code == null) return;
    setState(() {
      scanPnCtrl.text = code;

      final barcode = code.trim();
      final verification = materialPnCtrl.text.trim();

      scanResultPnCtrl.text = barcode == verification
          ? context.l10n.correct
          : context.l10n.wrong;
    });
  }

  Future<void> _scanLocker(
    BuildContext context,
    TextEditingController ctrl, {
    String? title,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ModernScannerScreen(title: title ?? context.l10n.scanLocker),
      ),
    );
    if (!mounted || code == null) return;
    setState(() => ctrl.text = code);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Reject Current Step
  // ══════════════════════════════════════════════════════════════════════════
  Future<void> onRejectPressed() async {
    if (selectedMR == null) {
      _showErrorSnackbar(context.l10n.selectMaterialRequest);
      return;
    }
    final result = await OtpRejectDialog.showByKey(
      context,
      stepKey: workflowStep,
    );

    if (result == null || !mounted) return;

    await _doSubmitReject(otp: result.otp, reason: result.rejectReason ?? '');
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SUBMIT WORKFLOW — MAIN ENTRY POINT
  // ══════════════════════════════════════════════════════════════════════════

  /// Được gọi khi người dùng nhấn nút Submit trong BaseWorkflowScreen.
  /// 1. Show OTP dialog
  /// 2. Validate form
  /// 3. Upload ảnh (nếu có)
  /// 4. Build payload
  /// 5. Call API submit
  /// 6. Handle response
  Future<void> onSubmitPressed() async {
    // Bước 1: Validate MR đã được chọn chưa
    if (selectedMR == null) {
      _showErrorSnackbar(context.l10n.selectMaterialRequest);
      return;
    }

    // Bước 2: Validate form theo step
    final validationError = _validateForm();
    if (validationError != null) {
      _showErrorSnackbar(validationError);
      return;
    }
    // Bước 3: Show OTP dialog
    final otp = await OtpDialog.showOtpSubmit(context);
    if (otp == null || !mounted) return;

    // Bước 4: Thực hiện submit
    await _doSubmit(otp);
  }

  /// Validate form theo workflowStep.
  /// Trả về null nếu hợp lệ, trả về thông báo lỗi nếu không hợp lệ.
  String? _validateForm() {
    // Validate ảnh khi là picture verification
    if (isPictureVerification && !photoPickerController.hasPhotos) {
      return context.l10n.pictureVerificationRequired;
    }

    // Validate scan result khi là scan verification
    if (isScanVerification &&
        barcodeCtrl.text.trim().isEmpty &&
        scanPcnCtrl.text.trim().isEmpty &&
        scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanBarcodeRequired;
    }
    if (isScanVerification &&
        barcodeCtrl.text.trim() != verificationCodeCtrl.text.trim() &&
        scanPcnCtrl.text.trim() != pcnCtrl.text.trim() &&
        scanPnCtrl.text.trim() != materialPnCtrl.text.trim()) {
      return context.l10n.barcodeNotMatch;
    }

    switch (workflowStep) {
      case 'preparer':
        return _validatePreparer();
      case 'warehouse':
        return _validateWarehouse();
      case 'receiver':
        return _validateReceiver();
      case 'line_leader':
        return _validateLineLeader();
      case 'production':
        return _validateProduction();
      default:
        return null;
    }
  }

  String? _validatePreparer() {
    if (_showLotInformation) {
      for (int i = 0; i < lots.length; i++) {
        final lot = lots[i];
        final lotName = '${context.l10n.lot} ${String.fromCharCode(65 + i)}';
        if (lot.nameController.text.trim().isEmpty) {
          return '${context.l10n.enterLotNameRequired} $lotName.';
        }
        final qty = double.tryParse(lot.qtyController.text.trim());
        if (qty == null || qty <= 0) {
          return '${context.l10n.enterLotQuantityRequired} $lotName.';
        }
      }
    }
    if (scanPcnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPcnRequired;
    }
    if (scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPnRequired;
    }
    if (lockerCtrl.text.trim().isEmpty) {
      return context.l10n.scanLockerRequired;
    }
    return null;
  }

  String? _validateWarehouse() {
    if (scanPcnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPcnRequired;
    }
    if (scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPnRequired;
    }
    if (warehouseLockerCtrl.text.trim().isEmpty) {
      return context.l10n.scanWarehouseLockerRequired;
    }
    return null;
  }

  String? _validateReceiver() {
    if (scanPcnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPcnRequired;
    }
    if (scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPnRequired;
    }
    if (productionLockerCtrl.text.trim().isEmpty) {
      return context.l10n.scanProductionLockerRequired;
    }
    if (warehouseKeeperCtrl.text.trim().isEmpty) {
      return context.l10n.enterReceivedBy;
    }
    // if (mrNameCtrl.text.trim().isEmpty) {
    //   return context.l10n.enterMrName;
    // }
    return null;
  }

  String? _validateLineLeader() {
    if (scanPcnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPcnRequired;
    }
    if (scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPnRequired;
    }
    if (productionLockerCtrl.text.trim().isEmpty) {
      return context.l10n.scanProductionLockerRequired;
    }
    if (receiverFromCtrl.text.trim().isEmpty) {
      return context.l10n.enterReceiverFrom;
    }

    return null;
  }

  String? _validateProduction() {
    if (quantityToProductionCtrl.text.trim().isEmpty) {
      return context.l10n.enterQuantityToProduction;
    }
    final qty = double.tryParse(quantityToProductionCtrl.text.trim());
    if (qty == null || qty <= 0) {
      return context.l10n.quantityMustBePositive;
    }
    if (scanPcnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPcnRequired;
    }
    if (scanPnCtrl.text.trim().isEmpty) {
      return context.l10n.scanPnRequired;
    }
    if (toWhereCtrl.text.trim().isEmpty) {
      return context.l10n.enterToWhere;
    }
    if (toWhoCtrl.text.trim().isEmpty) {
      return context.l10n.enterToWho;
    }
    if (fromLockerCtrl.text.trim().isEmpty) {
      return context.l10n.scanLockerRequired;
    }
    if (fromLeaderCtrl.text.trim().isEmpty) {
      return context.l10n.enterFromLeader;
    }
    // if (fromNameCtrl.text.trim().isEmpty) {
    //   return context.l10n.enterFromName;
    // }
    return null;
  }

  /// Thực hiện submit reject
  Future<void> _doSubmitReject({
    required String otp,
    required String reason,
  }) async {
    if (!mounted) return;

    setState(() => isSubmitting = true);

    try {
      final repo = context.read<MrWorkflowSubmitRepository>();
      final mrId = selectedMR!.id;
      final body = {
        "mr_request_id": mrId,
        "step": workflowStep,
        "reason": reason,
        "otp": otp,
      };

      // --- Call submit API ---
      final submitResponse = await repo.reject(body: body);

      if (!mounted) return;
      setState(() => isSubmitting = false);

      if (submitResponse.success) {
        _showSuccessSnackbar(
          submitResponse.message.isNotEmpty
              ? submitResponse.message
              : context.l10n.rejectSuccess,
        );
        // Refresh danh sách hoặc quay lại màn hình trước
        _onSubmitSuccess();
      } else {
        _showErrorSnackbar(
          submitResponse.message.isNotEmpty
              ? submitResponse.message
              : context.l10n.rejectFailed,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      debugPrint('[Reject] Error: $e');
      _showErrorSnackbar(_parseSubmitError(e));
    }
  }

  /// Thực hiện upload ảnh + submit workflow.
  Future<void> _doSubmit(String otp) async {
    if (!mounted) return;

    setState(() => isSubmitting = true);

    try {
      final repo = context.read<MrWorkflowSubmitRepository>();
      final mrId = selectedMR!.id;

      // --- Bước 1: Upload ảnh nếu có ---
      String? uploadedPicture;
      if (photoPickerController.hasPhotos && !isScanVerification) {
        final photoFile = File(photoPickerController.photos.first.path);
        debugPrint('[Submit] Uploading image: ${photoFile.path}');
        final uploadResponse = await repo.uploadImage(photoFile);
        if (uploadResponse.firstPath != null) {
          // Format: "[\"mms/uploads/xxx.png\"]"
          uploadedPicture = '["${uploadResponse.firstPath}"]';
          debugPrint('[Submit] Uploaded: $uploadedPicture');
        }
      }

      // --- Bước 2: Build payload theo step ---
      final body = _buildPayload(otp: otp, uploadedPicture: uploadedPicture);
      debugPrint('[Submit] Payload for step=$workflowStep: $body');

      // --- Bước 3: Call submit API ---
      final submitResponse = await repo.submit(
        step: workflowStep == 'production' ? 'consume' : workflowStep,
        mrRequestId: mrId,
        body: body,
      );

      if (!mounted) return;
      setState(() => isSubmitting = false);

      if (submitResponse.success) {
        _showSuccessSnackbar(
          submitResponse.message.isNotEmpty
              ? submitResponse.message
              : context.l10n.submitSuccess,
        );
        // Refresh danh sách hoặc quay lại màn hình trước
        _onSubmitSuccess();
      } else {
        _showErrorSnackbar(
          submitResponse.message.isNotEmpty
              ? submitResponse.message
              : context.l10n.submitFailed,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      debugPrint('[Submit] Error: $e');
      _showErrorSnackbar(_parseSubmitError(e));
    }
  }

  /// Build request body theo workflowStep.
  Map<String, dynamic> _buildPayload({
    required String otp,
    String? uploadedPicture,
  }) {
    final specCheck_ = specCheck;
    final quantityCheck_ = quantityCheck;
    final verifyMethod = verifyMethodCtrl.text.trim();
    final verificationCode = verificationCodeCtrl.text.trim();
    final barcodeScan = barcodeCtrl.text.trim();
    final scanResult = _scanResultValueForApi();

    switch (workflowStep) {
      case 'preparer':
        return {
          'quantity': null,
          'spec_check': specCheck_,
          'quantity_check': quantityCheck_,
          'verify_method': verifyMethod,
          'verification_code': verificationCode,
          'barcode_scan': barcodeScan,
          'locker': lockerCtrl.text.trim(),
          'pcn_scan': scanPcnCtrl.text.trim(),
          'material_pn_scan': scanPnCtrl.text.trim(),
          // 'person_name': preparerNameCtrl.text
          //     .trim(), // Preparer name field (no dedicated ctrl)
          'extra_data': {
            'lots': _buildLotsPayload(),
            'prepared_quantity': preparedQuantityCtrl.text.trim(),
            'difference': _calculateDifference(),
            'scan_result': scanResult,
          },
          'otp': otp,
          'spec_picture': uploadedPicture,
        };

      case 'warehouse':
        return {
          'spec_check': specCheck_,
          'quantity_check': quantityCheck_,
          'verify_method': verifyMethod,
          'verification_code': verificationCode,
          'barcode_scan': barcodeScan,
          'pcn_scan': scanPcnCtrl.text.trim(),
          'material_pn_scan': scanPnCtrl.text.trim(),
          'locker': warehouseLockerCtrl.text.trim(),
          'extra_data': {
            'difference': _calculateDifference(),
            'scan_result': scanResult,
          },
          'otp': otp,
          'spec_picture': uploadedPicture,
        };

      case 'receiver':
        return {
          'spec_check': specCheck_,
          'quantity_check': quantityCheck_,
          'verify_method': verifyMethod,
          'verification_code': verificationCode,
          'barcode_scan': barcodeScan,
          'pcn_scan': scanPcnCtrl.text.trim(),
          'material_pn_scan': scanPnCtrl.text.trim(),
          'locker': productionLockerCtrl.text.trim(),
          'person_name': '-',
          'extra_data': {
            'warehouse_keeper': warehouseKeeperCtrl.text.trim(),
            'scan_result': scanResult,
          },
          'otp': otp,
          'spec_picture': uploadedPicture,
        };

      case 'line_leader':
        return {
          'quantity': null,
          'spec_check': specCheck_,
          'quantity_check': quantityCheck_,
          'verify_method': verifyMethod,
          'verification_code': verificationCode,
          'barcode_scan': barcodeScan,
          'pcn_scan': scanPcnCtrl.text.trim(),
          'material_pn_scan': scanPnCtrl.text.trim(),
          'locker': productionLockerCtrl.text.trim(),
          'person_name': leaderNameCtrl.text.trim(),
          'extra_data': {
            'scan_result': scanResult,
            'received_from': receiverFromCtrl.text.trim(),
          },
          'otp': otp,
          'spec_picture': uploadedPicture,
        };

      case 'production':
        return {
          'quantity': null,
          'spec_check': specCheck_,
          'quantity_check': quantityCheck_,
          'verify_method': verifyMethod,
          'verification_code': verificationCode,
          'barcode_scan': barcodeScan,
          'pcn_scan': scanPcnCtrl.text.trim(),
          'material_pn_scan': scanPnCtrl.text.trim(),
          'locker': fromLockerCtrl.text.trim(),
          'person_name': fromNameCtrl.text.trim(),
          'extra_data': {
            'to_where': toWhereCtrl.text.trim(),
            'to_who': toWhoCtrl.text.trim(),
            'to_production_now': quantityToProductionCtrl.text.trim(),
            'from_leader': fromLeaderCtrl.text.trim(),
            'scan_result': scanResult,
          },
          'otp': otp,
          'spec_picture': uploadedPicture,
        };

      default:
        return {'otp': otp, 'spec_picture': uploadedPicture};
    }
  }

  /// Build danh sách lots cho preparer payload.
  List<Map<String, dynamic>> _buildLotsPayload() {
    return lots.map((lot) {
      return {
        'lot_name': lot.nameController.text.trim(),
        'quantity': double.tryParse(lot.qtyController.text.trim()) ?? 0,
      };
    }).toList();
  }

  /// Tính difference = preparedQuantity - requestQuantity.
  String _calculateDifference() {
    final prepared = double.tryParse(preparedQuantityCtrl.text.trim()) ?? 0;
    final requested = double.tryParse(selectedMR?.requestQuantity ?? '0') ?? 0;
    final diff = prepared - requested;
    return diff % 1 == 0 ? diff.toInt().toString() : diff.toStringAsFixed(2);
  }

  String _scanResultValueForApi() {
    final barcode = barcodeCtrl.text.trim();
    final verification = verificationCodeCtrl.text.trim();
    if (barcode.isEmpty || verification.isEmpty) {
      return scanResultCtrl.text.trim();
    }
    return barcode == verification ? 'correct' : 'wrong';
  }

  /// Sau khi submit thành công: refresh provider rồi pop về màn hình trước.
  void _onSubmitSuccess() {
    // Refresh danh sách workflow của step hiện tại
    try {
      final provider = context.read<MrWorkflowProvider>();
      provider.refresh();
    } catch (_) {
      // Provider không tồn tại ở màn hình này (ví dụ đã dispose)
    }

    // Quay về màn hình trước
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  /// Parse lỗi submit thành message thân thiện.
  String _parseSubmitError(Object e) {
    final msg = e.toString();
    if (msg.contains('SocketException') ||
        msg.contains('Network') ||
        msg.contains('ClientException')) {
      return context.l10n.networkError;
    }
    if (msg.contains('TimeoutException') || msg.contains('timed out')) {
      return context.l10n.timeoutError;
    }
    if (msg.contains('HTTP 5')) {
      return context.l10n.serverError;
    }
    if (msg.contains('OTP') || msg.contains('otp')) {
      return context.l10n.otpInvalid;
    }
    return context.l10n.submitError;
  }

  // ── Snackbar helpers ───────────────────────────────────────────────────────

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UI BUILDERS — CARDS
  // ══════════════════════════════════════════════════════════════════════════

  // ── Material Request Card ──────────────────────────────────────────────────
  Widget buildMaterialRequestCard(BuildContext context) {
    return WorkflowComponents.buildCard(
      title: context.l10n.materialRequest,
      icon: Icons.assignment_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: context.l10n.prepareDate,
            required: true,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.textTertiary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  prepareDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          WorkflowComponents.buildDivider(),

          GestureDetector(
            onTap: () => showMaterialRequestBottomSheet(context),
            child: WorkflowComponents.buildInfoRow(
              label: context.l10n.materialRequest,
              required: true,
              labelBold: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedMR?.displayTitle ??
                          context.l10n.tapToSelectChoice,
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedMR != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: selectedMR != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.requestNumber,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              requestNumberCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.workOrder,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              workOrderCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.demandWk,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              demandWkCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.pcn,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              pcnCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.finishGoodCtn,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              finishGoodCtnCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.materialPn,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              materialPnCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.materialName,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              materialNameCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.requestQuantity,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              requestQtyCtrl,
              context.l10n.autoFilled,
            ),
          ),
          WorkflowComponents.buildDivider(),

          WorkflowComponents.buildInfoRow(
            label: context.l10n.unit,
            required: true,
            child: WorkflowComponents.buildReadOnlyField(
              requestUnitCtrl,
              context.l10n.autoFilled,
            ),
          ),
        ],
      ),
    );
  }

  void showMaterialRequestBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<MrWorkflowProvider>(),
        child: MrWorkflowBottomSheet(
          selected: selectedMR,
          onSelected: onMRSelected,
        ),
      ),
    );
  }

  // ── Lot Information Card ───────────────────────────────────────────────────
  /// Trả về SizedBox.shrink() khi step là receiver / line_leader / production
  Widget buildLotInformationCard(BuildContext context) {
    if (!_showLotInformation) return const SizedBox.shrink();

    final isReadOnly = workflowStep == 'warehouse';

    return WorkflowComponents.buildCard(
      title: context.l10n.lotsInformation,
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      headerAction: isReadOnly
          ? null
          : InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  final lot = LotData();
                  lot.qtyController.addListener(updatePreparedQuantity);
                  lots.add(lot);
                  updatePreparedQuantity();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.addLot,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...lots.asMap().entries.map((entry) {
            final index = entry.key;
            final lot = entry.value;
            final lotLabel = String.fromCharCode(65 + index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WorkflowComponents.buildFieldLabel(
                    '${context.l10n.lot} $lotLabel',
                    required: !isReadOnly,
                  ),
                  const SizedBox(height: 6),
                  WorkflowComponents.buildTextField(
                    controller: lot.nameController,
                    hint: context.l10n.enterLotName,
                    readOnly: isReadOnly,
                  ),
                  const SizedBox(height: 12),
                  WorkflowComponents.buildFieldLabel(
                    '${context.l10n.lot} $lotLabel ${context.l10n.qty}',
                    required: !isReadOnly,
                  ),
                  const SizedBox(height: 6),
                  WorkflowComponents.buildTextField(
                    controller: lot.qtyController,
                    hint: '0',
                    suffixText: '#',
                    keyboardType: isReadOnly ? null : TextInputType.number,
                    readOnly: isReadOnly,
                    rightWidget: isReadOnly
                        ? null
                        : IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.error,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                lot.dispose();
                                lots.removeAt(index);
                                updatePreparedQuantity();
                              });
                            },
                          ),
                  ),
                  if (index != lots.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Divider(color: AppColors.cardBorder, height: 1),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Verification Card ──────────────────────────────────────────────────────
  Widget buildVerificationCard(BuildContext context) {
    final cardTitle = workflowStep == 'warehouse'
        ? context.l10n.warehouseVerification
        : context.l10n.verificationInfo;

    return WorkflowComponents.buildCard(
      title: cardTitle,
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildVerificationFields(context),
      ),
    );
  }

  List<Widget> _buildVerificationFields(BuildContext context) {
    switch (workflowStep) {
      case 'preparer':
        return _buildPreparerFields(context);
      case 'warehouse':
        return _buildWarehouseFields(context);
      case 'receiver':
        return _buildReceiverFields(context);
      case 'line_leader':
        return _buildLineLeaderFields(context);
      case 'production':
        return _buildProductionFields(context);

      default:
        return _buildPreparerFields(context);
    }
  }

  // ── Spec Picture Card ──────────────────────────────────────────────────────
  Widget buildSpecPictureCard(BuildContext context) {
    if (isScanVerification) return const SizedBox.shrink();

    return WorkflowComponents.buildCard(
      title: context.l10n.specPicture,
      icon: Icons.image_outlined,
      iconColor: AppColors.secondaryLight,
      iconBg: AppColors.secondarySurface,
      child: PhotoPickerWidget(controller: photoPickerController),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // VERIFICATION FIELD BUILDERS — mỗi step
  // ══════════════════════════════════════════════════════════════════════════

  // ── PREPARER — toàn bộ UI gốc ─────────────────────────────────────────────
  List<Widget> _buildPreparerFields(BuildContext context) {
    return [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(
                  context.l10n.preparedQuantity,
                ),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: preparedQuantityCtrl,
                  hint: locker,
                  suffixIcon: Icons.numbers_outlined,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.difference),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: differenceCtrl,
                  hint: preparerId,
                  suffixIcon: Icons.compare_arrows,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.verifyMethodPr),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: verifyMethodCtrl,
        hint: '-',
        suffixText: '#',
        readOnly: true,
      ),
      if (!isPictureVerification) ...[
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(
          context.l10n.barcodeScanPr,
          required: true,
        ),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: barcodeCtrl,
          hint: context.l10n.tapIconToScan,
          suffixIcon: Icons.qr_code_scanner,
          suffixIconColor: AppColors.primary,
          readOnly: true,
          onTapSuffix: () => _scanBarcode(context),
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.verificationCode),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: verificationCodeCtrl,
          hint: context.l10n.autoFilled,
          suffixText: '#',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.scanResult),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: scanResultCtrl,
          hint: context.l10n.scanResult,
          suffixIcon: Icons.security_outlined,
          readOnly: true,
        ),
      ],
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pcnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPcnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPCN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPcnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      // const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPN(context),
      ),
      // const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPcnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(width: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.locker, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: lockerCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(context, lockerCtrl),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.specCheck,
              specCheck,
              (v) => setState(() => specCheck = v!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.quantityCheck,
              quantityCheck,
              (v) => setState(() => quantityCheck = v!),
            ),
          ),
        ],
      ),
    ];
  }

  // ── WAREHOUSE ─────────────────────────────────────────────────────────────
  List<Widget> _buildWarehouseFields(BuildContext context) {
    return [
      WorkflowComponents.buildFieldLabel(context.l10n.difference),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: differenceCtrl,
        hint: preparerId,
        suffixIcon: Icons.compare_arrows,
        readOnly: true,
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.verifyMethod),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: verifyMethodCtrl,
        hint: '-',
        readOnly: true,
      ),
      if (!isPictureVerification) ...[
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.verificationCode),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: verificationCodeCtrl,
          hint: '-',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(
          context.l10n.barcodeScanPr,
          required: true,
        ),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: barcodeCtrl,
          hint: context.l10n.tapIconToScan,
          suffixIcon: Icons.qr_code_scanner,
          suffixIconColor: AppColors.primary,
          readOnly: true,
          onTapSuffix: () => _scanBarcode(context),
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.scanResult),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: scanResultCtrl,
          hint: context.l10n.scanResult,
          suffixIcon: Icons.security_outlined,
          readOnly: true,
        ),
      ],
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pcnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPcnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPCN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPcnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      // const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPcnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.warehouseLocker,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: warehouseLockerCtrl,
        hint: context.l10n.scanLocker,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          warehouseLockerCtrl,
          title: context.l10n.scanWarehouseLockerQr,
        ),
      ),
    ];
  }

  // ── RECEIVER ──────────────────────────────────────────────────────────────
  // Fields: Verify Method, Verification Code, Barcode Scan, Scan Result,
  //         Production Locker, Received By, MR Name
  // Ẩn: buildLotInformationCard
  List<Widget> _buildReceiverFields(BuildContext context) {
    return [
      WorkflowComponents.buildFieldLabel(context.l10n.verifyMethod),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: verifyMethodCtrl,
        hint: '-',
        readOnly: true,
      ),
      if (!isPictureVerification) ...[
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.verificationCode),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: verificationCodeCtrl,
          hint: '-',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(
          context.l10n.barcodeScan,
          required: true,
        ),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: barcodeCtrl,
          hint: context.l10n.tapIconToScan,
          suffixIcon: Icons.qr_code_scanner,
          suffixIconColor: AppColors.primary,
          readOnly: true,
          onTapSuffix: () => _scanBarcode(context),
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.scanResult),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: scanResultCtrl,
          hint: context.l10n.scanResult,
          suffixIcon: Icons.security_outlined,
          readOnly: true,
        ),
      ],
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pcnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPcnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPCN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPcnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      // const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPcnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.productionLocker,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: productionLockerCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          productionLockerCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.warehouseKeeper,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: warehouseKeeperCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          warehouseKeeperCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),
      const SizedBox(height: 12),
      // Row(
      //   children: [
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.receivedBy,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: warehouseKeeperCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.person_outline,
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(width: 12),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.mrName,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: mrNameCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.badge_outlined,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      // const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.specCheck,
              specCheck,
              (v) => setState(() => specCheck = v!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.quantityCheck,
              quantityCheck,
              (v) => setState(() => quantityCheck = v!),
            ),
          ),
        ],
      ),
    ];
  }

  // ── LINE LEADER ───────────────────────────────────────────────────────────
  List<Widget> _buildLineLeaderFields(BuildContext context) {
    return [
      WorkflowComponents.buildFieldLabel(context.l10n.verifyMethod),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: verifyMethodCtrl,
        hint: '-',
        readOnly: true,
      ),
      if (!isPictureVerification) ...[
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.verificationCode),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: verificationCodeCtrl,
          hint: '-',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(
          context.l10n.barcodeScan,
          required: true,
        ),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: barcodeCtrl,
          hint: context.l10n.tapIconToScan,
          suffixIcon: Icons.qr_code_scanner,
          suffixIconColor: AppColors.primary,
          readOnly: true,
          onTapSuffix: () => _scanBarcode(context),
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.scanResult),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: scanResultCtrl,
          hint: context.l10n.scanResult,
          suffixIcon: Icons.security_outlined,
          readOnly: true,
        ),
      ],
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pcnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPcnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPCN(context),
      ),
      // const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPcnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPN(context),
      ),
      const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      // const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPcnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.productionLocker,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: productionLockerCtrl,
        hint: context.l10n.scanLocker,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          productionLockerCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.receiverFrom,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: receiverFromCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          receiverFromCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),
      // Row(
      //   children: [
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.receiverFrom,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: receiverFromCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.person_outline,
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(width: 12),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.leaderName,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: leaderNameCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.supervisor_account_outlined,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.specCheck,
              specCheck,
              (v) => setState(() => specCheck = v!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.quantityCheck,
              quantityCheck,
              (v) => setState(() => quantityCheck = v!),
            ),
          ),
        ],
      ),
    ];
  }

  // ── PRODUCTION ────────────────────────────────────────────────────────────
  List<Widget> _buildProductionFields(BuildContext context) {
    return [
      WorkflowComponents.buildFieldLabel(
        context.l10n.quantityToProduction,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: quantityToProductionCtrl,
        hint: '0',
        suffixText: '#',
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.verifyMethod),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: verifyMethodCtrl,
        hint: '-',
        readOnly: true,
      ),
      if (!isPictureVerification) ...[
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.verificationCode),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: verificationCodeCtrl,
          hint: '-',
          readOnly: true,
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(
          context.l10n.barcodeScan,
          required: true,
        ),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: barcodeCtrl,
          hint: context.l10n.tapIconToScan,
          suffixIcon: Icons.qr_code_scanner,
          suffixIconColor: AppColors.primary,
          readOnly: true,
          onTapSuffix: () => _scanBarcode(context),
        ),
        const SizedBox(height: 12),
        WorkflowComponents.buildFieldLabel(context.l10n.scanResult),
        const SizedBox(height: 6),
        WorkflowComponents.buildTextField(
          controller: scanResultCtrl,
          hint: context.l10n.scanResult,
          suffixIcon: Icons.security_outlined,
          readOnly: true,
        ),
      ],
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pcnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPcnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPCN(context),
      ),
      // const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPcnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.pnScan, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: scanPnCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanPN(context),
      ),
      // const SizedBox(height: 12),
      // WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
      // const SizedBox(height: 6),
      // WorkflowComponents.buildTextField(
      //   controller: scanResultPnCtrl,
      //   hint: context.l10n.scanResult,
      //   suffixIcon: Icons.security_outlined,
      //   readOnly: true,
      // ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pcnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPcnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WorkflowComponents.buildFieldLabel(context.l10n.pnScanResult),
                const SizedBox(height: 6),
                WorkflowComponents.buildTextField(
                  controller: scanResultPnCtrl,
                  hint: context.l10n.scanResult,
                  suffixIcon: Icons.security_outlined,
                  readOnly: true,
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.toWhere, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: toWhereCtrl,
        suffixIcon: Icons.qr_code_scanner,
        hint: context.l10n.tapIconToScan,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          toWhereCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(context.l10n.toWho, required: true),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: toWhoCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          toWhoCtrl,
          title: context.l10n.scanProductionLockerQr,
        ),
      ),

      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.fromLocker,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: fromLockerCtrl,
        hint: context.l10n.scanLocker,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          fromLockerCtrl,
          title: context.l10n.scanFromLockerQr,
        ),
      ),
      const SizedBox(height: 12),
      WorkflowComponents.buildFieldLabel(
        context.l10n.fromLeader,
        required: true,
      ),
      const SizedBox(height: 6),
      WorkflowComponents.buildTextField(
        controller: fromLeaderCtrl,
        hint: context.l10n.tapIconToScan,
        suffixIcon: Icons.qr_code_scanner,
        suffixIconColor: AppColors.primary,
        readOnly: true,
        onTapSuffix: () => _scanLocker(
          context,
          fromLeaderCtrl,
          title: context.l10n.scanFromLockerQr,
        ),
      ),
      // Row(
      //   children: [
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.fromLeader,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: fromLeaderCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.supervisor_account_outlined,
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(width: 12),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           WorkflowComponents.buildFieldLabel(
      //             context.l10n.fromName,
      //             required: true,
      //           ),
      //           const SizedBox(height: 6),
      //           WorkflowComponents.buildTextField(
      //             controller: fromNameCtrl,
      //             hint: '-',
      //             suffixIcon: Icons.badge_outlined,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.specCheck,
              specCheck,
              (v) => setState(() => specCheck = v!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: WorkflowComponents.buildCheckboxItem(
              context.l10n.quantityCheck,
              quantityCheck,
              (v) => setState(() => quantityCheck = v!),
            ),
          ),
        ],
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// MATERIAL REQUEST BOTTOM SHEET — real API data via Provider
// ---------------------------------------------------------------------------
class MrWorkflowBottomSheet extends StatefulWidget {
  final MrWorkflowItemModel? selected;
  final ValueChanged<MrWorkflowItemModel> onSelected;

  const MrWorkflowBottomSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<MrWorkflowBottomSheet> createState() => _MrWorkflowBottomSheetState();
}

class _MrWorkflowBottomSheetState extends State<MrWorkflowBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  String _searchQuery = '';
  String _groupBy = 'none';
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
    _scrollCtrl.addListener(_onScroll);
    // Load fresh data every time the bottom sheet is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MrWorkflowProvider>().fetch();
    });
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchCtrl.text.toLowerCase();
    });
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<MrWorkflowProvider>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  List<MrWorkflowItemModel> _getFiltered(List<MrWorkflowItemModel> items) {
    var result = items;
    if (_filterStatus != 'All') {
      result = result.where((e) => e.currentStatus == _filterStatus).toList();
    }
    if (_searchQuery.isEmpty) return result;
    return result.where((e) {
      return e.id.toLowerCase().contains(_searchQuery) ||
          e.materialName.toLowerCase().contains(_searchQuery) ||
          e.materialPn.toLowerCase().contains(_searchQuery) ||
          e.workOrder.toLowerCase().contains(_searchQuery) ||
          e.requestNumber.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final availableHeight =
        mediaQuery.size.height - keyboardHeight - mediaQuery.padding.top - 12;
    final maxSheetHeight = math.min(
      mediaQuery.size.height * 0.85,
      math.max(availableHeight, 0.0),
    );

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.list_alt_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<MrWorkflowProvider>(
                        builder: (_, provider, __) => Text(
                          '${context.l10n.materialRequest} (${provider.total})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: AppColors.cardBorder),

                // Search box
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: context.l10n.searchByIdName,
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.textTertiary,
                              ),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Group & Filter Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Grouping
                        Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _groupBy,
                              isDense: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'none',
                                  child: Text('No Grouping'),
                                ),
                                DropdownMenuItem(
                                  value: 'pcn',
                                  child: Text('Group by PCN'),
                                ),
                                DropdownMenuItem(
                                  value: 'materialPn',
                                  child: Text('Group by Material PN'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _groupBy = val);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Filter by currentStatus
                        Consumer<MrWorkflowProvider>(
                          builder: (context, provider, _) {
                            final statuses = provider.items
                                .map((e) => e.currentStatus)
                                .where((e) => e.isNotEmpty)
                                .toSet()
                                .toList();
                            statuses.sort();
                            statuses.insert(0, 'All');

                            // If current filter is invalid, reset to 'All'
                            final currentValue =
                                statuses.contains(_filterStatus)
                                ? _filterStatus
                                : 'All';

                            return Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: currentValue,
                                  isDense: true,
                                  icon: const Icon(
                                    Icons.filter_list,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                  items: statuses.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(
                                        status == 'All'
                                            ? 'All Statuses'
                                            : status,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _filterStatus = val);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // List with states
                Flexible(
                  child: Consumer<MrWorkflowProvider>(
                    builder: (context, provider, _) {
                      // Loading
                      if (provider.isLoading && provider.items.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(48),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }

                      // Error
                      if (provider.hasError && provider.items.isEmpty) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.errorMessage ??
                                    context.l10n.anErrorOccurred,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () => provider.fetch(),
                                icon: const Icon(Icons.refresh, size: 18),
                                label: Text(context.l10n.retry),
                              ),
                            ],
                          ),
                        );
                      }

                      final filtered = _getFiltered(provider.items);

                      // Empty
                      if (filtered.isEmpty) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                color: AppColors.textTertiary,
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.noResultsFound,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Grouping Logic
                      List<dynamic> displayItems = [];
                      if (_groupBy != 'none') {
                        final sorted = List<MrWorkflowItemModel>.from(filtered);
                        sorted.sort((a, b) {
                          final keyA = _groupBy == 'pcn' ? a.pcn : a.materialPn;
                          final keyB = _groupBy == 'pcn' ? b.pcn : b.materialPn;
                          return keyA.compareTo(keyB);
                        });
                        String? currentGroup;
                        for (final item in sorted) {
                          final key = _groupBy == 'pcn'
                              ? item.pcn
                              : item.materialPn;
                          final groupKey = key.isEmpty ? 'Unknown' : key;
                          if (groupKey != currentGroup) {
                            currentGroup = groupKey;
                            displayItems.add(currentGroup);
                          }
                          displayItems.add(item);
                        }
                      } else {
                        displayItems = List.from(filtered);
                      }

                      // List with pagination
                      return ListView.builder(
                        controller: _scrollCtrl,
                        itemCount:
                            displayItems.length +
                            (provider.isLoadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          // Loading more footer
                          if (i >= displayItems.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final itemOrHeader = displayItems[i];
                          if (itemOrHeader is String) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: AppColors.surfaceVariant.withValues(
                                alpha: 0.3,
                              ),
                              child: Text(
                                '${_groupBy == 'pcn' ? 'PCN' : 'Material PN'}: $itemOrHeader',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }

                          final item = itemOrHeader as MrWorkflowItemModel;
                          final isSelected = widget.selected?.id == item.id;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () => widget.onSelected(item),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                                leading: SizedBox(
                                  width: 50,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primarySurface
                                              : item.isRejected
                                              ? AppColors.error.withValues(
                                                  alpha: 0.1,
                                                )
                                              : AppColors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          item.isRejected
                                              ? Icons.warning_amber_rounded
                                              : Icons.assignment_outlined,
                                          color: isSelected
                                              ? AppColors.primary
                                              : item.isRejected
                                              ? AppColors.error
                                              : AppColors.textTertiary,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.currentStatus,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.displayTitle,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.materialName,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: AppColors.primary,
                                        size: 20,
                                      )
                                    : const Icon(
                                        Icons.chevron_right,
                                        color: AppColors.textTertiary,
                                        size: 20,
                                      ),
                              ),
                              if (i < displayItems.length - 1 &&
                                  displayItems[i + 1] is MrWorkflowItemModel)
                                const Divider(
                                  height: 1,
                                  color: AppColors.cardBorder,
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
