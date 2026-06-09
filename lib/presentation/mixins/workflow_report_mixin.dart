import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../components/workflow_components.dart';

mixin WorkflowReportMixin<T extends StatefulWidget> on State<T> {
  // Build Section 1: Material Request Information
  Widget buildMaterialRequestInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    return WorkflowComponents.buildCard(
      title: 'Material Request',
      icon: Icons.assignment_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: 'Request Status',
            child: Text(
              report.requestStatus.isNotEmpty ? report.requestStatus : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Request Number',
            child: Text(
              '${report.requestNumber} - ${report.workOrder} - ${report.materialPn}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Request Date',
            child: Text(
              report.requestDate.isNotEmpty ? report.requestDate : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Work Order',
            child: Text(
              report.workOrder,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Demand Week',
            child: Text(
              report.demandWk,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'PCN',
            child: Text(
              report.pcn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Finish Good / CTN',
            child: Text(
              report.finishGoodCtn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Material P/N',
            child: Text(
              report.materialPn,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Material Name',
            child: Text(
              report.materialName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Request Quantity',
            child: Text(
              report.requestQuantity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Unit',
            child: Text(
              report.unit,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Section 3: Verification
  Widget buildVerification(BuildContext context, WorkflowReportEntity report) {
    return WorkflowComponents.buildCard(
      title: 'Verification',
      icon: Icons.fact_check_outlined,
      iconColor: AppColors.info,
      iconBg: AppColors.infoSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: 'Verification Method',
            child: Text(
              report.verificationMethod ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Verification Code',
            child: Text(
              report.verificationCode ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Spec Check',
            child: Text(
              report.specCheck == '1'
                  ? 'Correct'
                  : report.specCheck == '0'
                  ? 'Wrong'
                  : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Quantity Check',
            child: Text(
              // report.quantityCheck.isNotEmpty ? report.quantityCheck : '-',
              report.quantityCheck == '1'
                  ? 'Correct'
                  : report.quantityCheck == '0'
                  ? 'Wrong'
                  : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Locker',
            child: Text(
              report.locker.isNotEmpty ? report.locker : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Section 4: Workflow Information
  Widget buildWorkflowInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    return WorkflowComponents.buildCard(
      title: 'Workflow Information',
      icon: Icons.timeline_outlined,
      iconColor: AppColors.secondary,
      iconBg: AppColors.secondarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: 'Current Step',
            child: Text(
              report.stepName.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Current Status',
            child: Text(
              report.stepStatus,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Action Date',
            child: Text(
              report.actionDate ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Section 5: Quantity Information
  Widget buildQuantityInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    return WorkflowComponents.buildCard(
      title: 'Quantity Information',
      icon: Icons.bar_chart_outlined,
      iconColor: AppColors.success,
      iconBg: AppColors.successSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: 'Prepared Material Received',
            child: Text(
              report.preparedQuantity.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // if (report.totalToProduction != null) ...[
          //   WorkflowComponents.buildDivider(),
          //   WorkflowComponents.buildInfoRow(
          //     label: 'Total To Production',
          //     child: Text(
          //       report.totalToProduction.toString(),
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //         color: AppColors.textPrimary,
          //       ),
          //     ),
          //   ),
          // ],
          // if (report.currentMaterialBalance != null) ...[
          //   WorkflowComponents.buildDivider(),
          //   WorkflowComponents.buildInfoRow(
          //     label: 'Current Material Balance',
          //     child: Text(
          //       report.currentMaterialBalance.toString(),
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //         color: AppColors.textPrimary,
          //       ),
          //     ),
          //   ),
          // ],
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: 'Difference',
            child: Text(
              report.difference.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: report.difference < 0
                    ? AppColors.error
                    : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Section 6: Lot Information
  Widget buildLotInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    if (report.lots.isEmpty) {
      return const SizedBox.shrink();
    }

    return WorkflowComponents.buildCard(
      title: 'Lot Information',
      icon: Icons.layers_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: report.lots.asMap().entries.map((entry) {
          final index = entry.key;
          final lot = entry.value;
          return Column(
            children: [
              if (index > 0) WorkflowComponents.buildDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lot.lotName.isNotEmpty ? lot.lotName : 'Lot ${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    lot.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Build Section 7: Pictures
  Widget buildPictures(BuildContext context, WorkflowReportEntity report) {
    if (report.specPictures.isEmpty) {
      return const SizedBox.shrink();
    }

    return WorkflowComponents.buildCard(
      title: 'Spec Pictures',
      icon: Icons.image_outlined,
      iconColor: AppColors.info,
      iconBg: AppColors.infoSurface,
      child: SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: report.specPictures.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                report.specPictures[index],
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
