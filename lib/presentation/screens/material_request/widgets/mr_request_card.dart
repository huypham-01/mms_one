import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';

/// Material request card widget for the MR listing screen.
class MrRequestCard extends StatelessWidget {
  const MrRequestCard({
    super.key,
    required this.requestNumber,
    required this.workOrder,
    required this.materialPn,
    required this.materialName,
    required this.requestQuantity,
    required this.unit,
    required this.currentStatus,
    required this.currentStep,
    required this.requestDate,
    this.onTap,
  });

  final String requestNumber;
  final String workOrder;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;
  final String currentStatus;
  final String currentStep;
  final String requestDate;
  final VoidCallback? onTap;

  Color get _stepColor {
    final lower = currentStep.toLowerCase();
    if (lower.contains('urgent') || lower.contains('high')) return AppColors.error;
    if (lower.contains('medium') || lower.contains('normal')) return AppColors.warning;
    return AppColors.info;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.description_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(requestNumber, style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary, letterSpacing: -0.2,
                        )),
                        const SizedBox(height: 2),
                        Text(requestDate.isNotEmpty ? requestDate : '—',
                          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                  StatusChip(label: currentStatus),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.work_outline_rounded, label: 'Work Order', value: workOrder),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.inventory_2_outlined, label: 'Material',
                    value: '$materialPn — $materialName', valueMaxLines: 2),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primaryBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.straighten_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('$requestQuantity $unit', style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _stepColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag_outlined, size: 12, color: _stepColor),
                            const SizedBox(width: 4),
                            Text(currentStep, style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600, color: _stepColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.valueMaxLines = 1});
  final IconData icon;
  final String label;
  final String value;
  final int valueMaxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        SizedBox(width: 72, child: Text(label, style: const TextStyle(
          fontSize: 12, color: AppColors.textTertiary, fontWeight: FontWeight.w500))),
        Expanded(child: Text(value, maxLines: valueMaxLines, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
      ],
    );
  }
}
