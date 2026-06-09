import 'package:flutter/material.dart';
import '../controllers/workflow_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/components/workflow_components.dart';
import '../../../presentation/widgets/photo_picker_widget.dart';

class LotData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
  }
}

class DynamicWorkflowForm extends StatelessWidget {
  final WorkflowStep step;
  final WorkflowController controller;
  final List<LotData> lots;
  final VoidCallback onAddLot;
  final Function(int index) onRemoveLot;
  final PhotoPickerController photoController;
  final Map<String, TextEditingController> textControllers;
  final Function(BuildContext context, TextEditingController ctrl, String title) onScanRequested;

  const DynamicWorkflowForm({
    super.key,
    required this.step,
    required this.controller,
    required this.lots,
    required this.onAddLot,
    required this.onRemoveLot,
    required this.photoController,
    required this.textControllers,
    required this.onScanRequested,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMR = controller.selectedMR;
    if (selectedMR == null) {
      return const SizedBox.shrink();
    }

    final isPictureVerification = selectedMR.verificationMethod?.toLowerCase() == 'picture';
    final isScanVerification = selectedMR.verificationMethod?.toLowerCase() == 'scan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. PHƯƠNG THỨC XÁC THỰC CHUNG (PICTURE / SCAN) ──────────────────
        if (isPictureVerification) ...[
          const SizedBox(height: 16),
          WorkflowComponents.buildCard(
            title: 'Hình ảnh xác thực',
            icon: Icons.camera_alt_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primarySurface,
            child: PhotoPickerWidget(controller: photoController),
          ),
        ],

        if (isScanVerification) ...[
          const SizedBox(height: 16),
          WorkflowComponents.buildCard(
            title: 'Quét Barcode xác thực',
            icon: Icons.qr_code_scanner_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primarySurface,
            child: Column(
              children: [
                WorkflowComponents.buildInfoRow(
                  label: 'Verification Code',
                  required: true,
                  child: Text(
                    selectedMR.verificationCode ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                WorkflowComponents.buildDivider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textControllers['barcode_scan'],
                        decoration: const InputDecoration(
                          hintText: 'Nhấn nút quét hoặc nhập mã',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => onScanRequested(
                        context,
                        textControllers['barcode_scan']!,
                        'Quét Barcode sản phẩm',
                      ),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        // ── 2. CÁC TRƯỜNG DỮ LIỆU ĐẶC THÙ THEO STEP ─────────────────────────
        const SizedBox(height: 16),
        _buildStepSpecificFields(context),
      ],
    );
  }

  Widget _buildStepSpecificFields(BuildContext context) {
    switch (step) {
      case WorkflowStep.preparer:
        return Column(
          children: [
            // Quản lý lô (Lots)
            WorkflowComponents.buildCard(
              title: 'Thông tin Lot',
              icon: Icons.grid_on_outlined,
              iconColor: AppColors.primary,
              iconBg: AppColors.primarySurface,
              headerAction: TextButton.icon(
                onPressed: onAddLot,
                icon: const Icon(Icons.add),
                label: const Text('Thêm Lot'),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lots.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lot = lots[index];
                  return Row(
                    children: [
                      CircleAvatar(
                        child: Text(String.fromCharCode(65 + index)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: lot.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Tên Lot',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: lot.qtyController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Số lượng',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      if (lots.length > 1) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () => onRemoveLot(index),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildLockerScanCard(
              context,
              key: 'locker',
              label: 'Scan Locker',
              title: 'Quét mã QR của Locker',
            ),
          ],
        );

      case WorkflowStep.warehouse:
        return _buildLockerScanCard(
          context,
          key: 'warehouse_locker',
          label: 'Scan Warehouse Locker',
          title: 'Quét mã QR của Warehouse Locker',
        );

      case WorkflowStep.receiver:
        return WorkflowComponents.buildCard(
          title: 'Thông tin người nhận',
          icon: Icons.person_outline,
          iconColor: AppColors.primary,
          iconBg: AppColors.primarySurface,
          child: Column(
            children: [
              _buildLockerScanRow(
                context,
                key: 'production_locker',
                label: 'Scan Production Locker',
                title: 'Quét mã QR của Production Locker',
              ),
              WorkflowComponents.buildDivider(),
              TextField(
                controller: textControllers['received_by'],
                decoration: const InputDecoration(
                  labelText: 'Received By (Họ tên người nhận)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textControllers['mr_name'],
                decoration: const InputDecoration(
                  labelText: 'MR Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );

      case WorkflowStep.lineLeader:
        return WorkflowComponents.buildCard(
          title: 'Xác nhận Tổ trưởng (Line Leader)',
          icon: Icons.verified_user_outlined,
          iconColor: AppColors.primary,
          iconBg: AppColors.primarySurface,
          child: Column(
            children: [
              _buildLockerScanRow(
                context,
                key: 'production_locker',
                label: 'Scan Production Locker',
                title: 'Quét mã QR của Production Locker',
              ),
              WorkflowComponents.buildDivider(),
              TextField(
                controller: textControllers['receiver_from'],
                decoration: const InputDecoration(
                  labelText: 'Receiver From',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textControllers['leader_name'],
                decoration: const InputDecoration(
                  labelText: 'Leader Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );

      case WorkflowStep.production:
        return WorkflowComponents.buildCard(
          title: 'Cấp phát sản xuất (Production)',
          icon: Icons.factory_outlined,
          iconColor: AppColors.primary,
          iconBg: AppColors.primarySurface,
          child: Column(
            children: [
              TextField(
                controller: textControllers['qty_to_production'],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity to Production (Số lượng)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textControllers['to_where'],
                decoration: const InputDecoration(
                  labelText: 'To Where (Chuyển đi đâu)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textControllers['to_who'],
                decoration: const InputDecoration(
                  labelText: 'To Who (Chuyển cho ai)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              _buildLockerScanRow(
                context,
                key: 'from_locker',
                label: 'Scan From Locker',
                title: 'Quét mã QR của Locker cấp phát',
              ),
              WorkflowComponents.buildDivider(),
              TextField(
                controller: textControllers['from_leader'],
                decoration: const InputDecoration(
                  labelText: 'From Leader',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textControllers['from_name'],
                decoration: const InputDecoration(
                  labelText: 'From Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildLockerScanCard(
    BuildContext context, {
    required String key,
    required String label,
    required String title,
  }) {
    return WorkflowComponents.buildCard(
      title: label,
      icon: Icons.qr_code_scanner,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textControllers[key],
              decoration: InputDecoration(
                hintText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: () => onScanRequested(context, textControllers[key]!, title),
            icon: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
    );
  }

  Widget _buildLockerScanRow(
    BuildContext context, {
    required String key,
    required String label,
    required String title,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textControllers[key],
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: () => onScanRequested(context, textControllers[key]!, title),
          icon: const Icon(Icons.qr_code_scanner),
        ),
      ],
    );
  }
}
