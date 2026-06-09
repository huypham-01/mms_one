import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Material request card widget for the MR listing screen.
class MrRequestReportCard extends StatelessWidget {
  const MrRequestReportCard({
    super.key,
    required this.requestNumber,
    required this.workOrder,
    required this.demandWk,
    required this.pcn,
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
  final String demandWk;
  final String pcn;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;
  final String currentStatus;
  final String currentStep;
  final String requestDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requestNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$workOrder,$demandWk ,$pcn",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
