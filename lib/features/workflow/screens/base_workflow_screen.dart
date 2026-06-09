import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/workflow_controller.dart';
import '../widgets/dynamic_workflow_form.dart';
import '../../../presentation/components/workflow_components.dart';
import '../../../presentation/widgets/photo_picker_widget.dart';
import '../../../presentation/widgets/modern_scanner_screen.dart';
import '../../../presentation/widgets/otp_dialog.dart';
import '../../../presentation/widgets/otp_reject_dialog.dart' hide WorkflowStep;

class BaseWorkflowScreen extends StatefulWidget {
  final WorkflowStep step;

  const BaseWorkflowScreen({super.key, required this.step});

  @override
  State<BaseWorkflowScreen> createState() => _BaseWorkflowScreenState();
}

class _BaseWorkflowScreenState extends State<BaseWorkflowScreen> {
  final Map<String, TextEditingController> _textControllers = {};
  final List<LotData> _lots = [LotData()];
  final PhotoPickerController _photoController = PhotoPickerController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    
    // Fetch dữ liệu sau khi widget được dựng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkflowController>().fetchWorkflowItems(widget.step);
    });
  }

  void _initializeControllers() {
    // Khởi tạo các controller chung
    _textControllers['barcode_scan'] = TextEditingController();
    _textControllers['locker'] = TextEditingController();
    _textControllers['warehouse_locker'] = TextEditingController();
    _textControllers['production_locker'] = TextEditingController();
    _textControllers['received_by'] = TextEditingController();
    _textControllers['mr_name'] = TextEditingController();
    _textControllers['receiver_from'] = TextEditingController();
    _textControllers['leader_name'] = TextEditingController();
    _textControllers['qty_to_production'] = TextEditingController();
    _textControllers['to_where'] = TextEditingController();
    _textControllers['to_who'] = TextEditingController();
    _textControllers['from_locker'] = TextEditingController();
    _textControllers['from_leader'] = TextEditingController();
    _textControllers['from_name'] = TextEditingController();
  }

  @override
  void dispose() {
    for (var ctrl in _textControllers.values) {
      ctrl.dispose();
    }
    for (var lot in _lots) {
      lot.dispose();
    }
    _photoController.dispose();
    super.dispose();
  }

  // Quét mã QR/Barcode và gán vào controller
  Future<void> _scanField(BuildContext context, TextEditingController ctrl, String title) async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ModernScannerScreen(title: title),
      ),
    );
    if (scannedCode != null && mounted) {
      setState(() {
        ctrl.text = scannedCode;
      });
    }
  }

  // Thêm Lot mới (chỉ dùng cho Preparer)
  void _onAddLot() {
    setState(() {
      _lots.add(LotData());
    });
  }

  // Xóa Lot (chỉ dùng cho Preparer)
  void _onRemoveLot(int index) {
    setState(() {
      _lots[index].dispose();
      _lots.removeAt(index);
    });
  }

  // Tính tổng số lượng Prepared từ danh sách Lots
  double _calculatePreparedQty() {
    double total = 0;
    for (var lot in _lots) {
      final qty = double.tryParse(lot.qtyController.text.trim()) ?? 0;
      total += qty;
    }
    return total;
  }

  // Tính chênh lệch Prepared - Requested
  double _calculateDifference(double requestedQty) {
    return _calculatePreparedQty() - requestedQty;
  }

  // Gửi thông báo SnackBar
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Xử lý nút Submit Xác nhận
  Future<void> _onSubmit(WorkflowController controller) async {
    final selectedMR = controller.selectedMR;
    if (selectedMR == null) {
      _showSnackBar('Vui lòng chọn Material Request trước.', isError: true);
      return;
    }

    // Thu thập dữ liệu input từ Form UI
    final Map<String, dynamic> rawInput = {};
    _textControllers.forEach((key, ctrl) {
      rawInput[key] = ctrl.text.trim();
    });

    // Thêm dữ liệu Lot và Tính toán số lượng cho Preparer
    final requestedQty = double.tryParse(selectedMR.requestQuantity) ?? 0;
    final preparedQty = _calculatePreparedQty();
    final diff = _calculateDifference(requestedQty);

    rawInput['lots'] = _lots.map((l) => {
      'lot_name': l.nameController.text.trim(),
      'qty': double.tryParse(l.qtyController.text.trim()) ?? 0,
    }).toList();
    rawInput['prepared_quantity'] = preparedQty.toString();
    rawInput['difference'] = diff.toString();

    // 1. Validate Form động thông qua Controller
    final validationError = controller.validateForm(
      step: widget.step,
      rawInput: rawInput,
      hasPhotos: _photoController.hasPhotos,
    );

    if (validationError != null) {
      _showSnackBar(validationError, isError: true);
      return;
    }

    // 2. Hiện Dialog OTP submit
    final otp = await OtpDialog.showOtpSubmit(context);
    if (otp == null || !mounted) return;

    // 3. Thực hiện Submit qua API trong Controller
    final success = await controller.submitWorkflow(
      step: widget.step,
      rawInput: rawInput,
      otp: otp,
      photoFile: _photoController.hasPhotos ? File(_photoController.photos.first.path) : null,
    );

    if (success) {
      _showSnackBar('Gửi yêu cầu xác nhận thành công!');
      if (mounted) Navigator.of(context).pop(true);
    } else {
      _showSnackBar(controller.errorMessage ?? 'Xảy ra lỗi khi gửi yêu cầu.', isError: true);
    }
  }

  // Xử lý nút Reject Từ chối
  Future<void> _onReject(WorkflowController controller) async {
    final selectedMR = controller.selectedMR;
    if (selectedMR == null) {
      _showSnackBar('Vui lòng chọn Material Request trước.', isError: true);
      return;
    }

    // Hiện Dialog OTP Reject
    final rejectResult = await OtpRejectDialog.showByKey(context, stepKey: widget.step.key);
    if (rejectResult == null || !mounted) return;

    // Lấy lý do từ chối
    final reason = rejectResult.rejectReason ?? 'Từ chối bởi ${widget.step.label}';

    final success = await controller.rejectWorkflow(
      step: widget.step,
      reason: reason,
      otp: rejectResult.otp,
    );

    if (success) {
      _showSnackBar('Đã từ chối yêu cầu thành công.');
      if (mounted) Navigator.of(context).pop(true);
    } else {
      _showSnackBar(controller.errorMessage ?? 'Xảy ra lỗi khi từ chối yêu cầu.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkflowController>(
      builder: (context, controller, child) {
        final selectedMR = controller.selectedMR;

        return Scaffold(
          appBar: AppBar(
            title: Text('Workflow: ${widget.step.label}'),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── 1. MATERIAL REQUEST CARD SELECTOR ────────────────
                      WorkflowComponents.buildCard(
                        title: 'Material Request',
                        icon: Icons.assignment_outlined,
                        iconColor: AppColors.primary,
                        iconBg: AppColors.primarySurface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () => _showMRSelectorBottomSheet(context, controller),
                              child: WorkflowComponents.buildInfoRow(
                                label: 'Chọn Yêu Cầu (Material Request)',
                                required: true,
                                labelBold: true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedMR != null
                                            ? selectedMR.displayTitle
                                            : 'Nhấn để chọn Material Request',
                                        style: TextStyle(
                                          fontWeight: selectedMR != null ? FontWeight.bold : FontWeight.normal,
                                          color: selectedMR != null ? Colors.black : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                            if (selectedMR != null) ...[
                              WorkflowComponents.buildDivider(),
                              WorkflowComponents.buildInfoRow(
                                label: 'Request Number',
                                child: Text(selectedMR.requestNumber),
                              ),
                              WorkflowComponents.buildDivider(),
                              WorkflowComponents.buildInfoRow(
                                label: 'Material P/N',
                                child: Text(selectedMR.materialPn),
                              ),
                              WorkflowComponents.buildDivider(),
                              WorkflowComponents.buildInfoRow(
                                label: 'Requested Qty',
                                child: Text('${selectedMR.requestQuantity} ${selectedMR.unit}'),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // ── 2. DYNAMIC WORKFLOW FORM ──────────────────────────
                      if (selectedMR != null) ...[
                        DynamicWorkflowForm(
                          step: widget.step,
                          controller: controller,
                          lots: _lots,
                          onAddLot: _onAddLot,
                          onRemoveLot: _onRemoveLot,
                          photoController: _photoController,
                          textControllers: _textControllers,
                          onScanRequested: _scanField,
                        ),
                        const SizedBox(height: 24),

                        // ── 3. ACTION BUTTONS (SUBMIT / REJECT) ───────────────
                        controller.isSubmitting
                            ? const Center(child: CircularProgressIndicator())
                            : Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _onReject(controller),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('TỪ CHỐI'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => _onSubmit(controller),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Text('XÁC NHẬN'),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _showMRSelectorBottomSheet(BuildContext context, WorkflowController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Danh sách Material Requests',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              controller.items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'Không có yêu cầu nào chờ xử lý.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = controller.items[index];
                          return ListTile(
                            title: Text(item.displayTitle),
                            subtitle: Text('Status: ${item.currentStatus} | Step: ${item.currentStep}'),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                            onTap: () {
                              controller.selectMR(item);
                              Navigator.pop(sheetContext);
                            },
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      },
    );
  }
}
