import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/workflow_report_entity.dart';
import '../../l10n/app_localizations.dart';
import '../components/workflow_components.dart';

mixin WorkflowReportMixin<T extends StatefulWidget> on State<T> {
  // Build Section 1: Material Request Information
  Widget buildMaterialRequestInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: l10n.materialRequestInformation,
      icon: Icons.assignment_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // WorkflowComponents.buildInfoRow(
          //   label: l10n.requestStatus,
          //   child: Text(
          //     report.requestStatus.isNotEmpty ? report.requestStatus : '-',
          //     style: const TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w700,
          //       color: AppColors.primary,
          //     ),
          //   ),
          // ),
          // WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: l10n.requestNumber,
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
            label: l10n.requestDate,
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
            label: l10n.workOrder,
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
            label: l10n.demandWk,
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
            label: l10n.pcn,
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
            label: l10n.finishGoodCtn,
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
            label: l10n.materialPn,
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
            label: l10n.materialName,
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
            label: l10n.requestQuantity,
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
            label: l10n.unit,
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
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: l10n.verificationInfo,
      icon: Icons.fact_check_outlined,
      iconColor: AppColors.info,
      iconBg: AppColors.infoSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.verificationMethod,
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
            label: l10n.verificationCode,
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
            label: l10n.specCheck,
            child: Text(
              report.specCheck == '1'
                  ? l10n.correct
                  : report.specCheck == '0'
                  ? l10n.wrong
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
            label: l10n.quantityCheck,
            child: Text(
              report.quantityCheck == '1'
                  ? l10n.correct
                  : report.quantityCheck == '0'
                  ? l10n.wrong
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
            label: l10n.locker,
            child: Text(
              report.locker.isNotEmpty ? report.locker : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // if (report.scanResult != null && report.scanResult!.isNotEmpty) ...[
          //   WorkflowComponents.buildDivider(),
          //   WorkflowComponents.buildInfoRow(
          //     label: l10n.scanResult,
          //     child: Text(
          //       report.scanResult!,
          //       style: TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w600,
          //         color: report.scanResult!.toLowerCase() == l10n.correct.toLowerCase() || report.scanResult!.toLowerCase() == 'correct'
          //             ? AppColors.success
          //             : (report.scanResult!.toLowerCase() == l10n.wrong.toLowerCase() || report.scanResult!.toLowerCase() == 'wrong' ? AppColors.error : AppColors.textPrimary),
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  // Build Section: Receiver Information
  Widget buildReceiverInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: 'Receiver Information', // Fallback or could use l10n
      icon: Icons.person_outline,
      iconColor: AppColors.warning,
      iconBg: AppColors.warningSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.warehouseKeeper,
            child: Text(
              report.warehouseKeeper?.isNotEmpty == true
                  ? report.warehouseKeeper!
                  : '-',
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

  // Build Section: Line Leader Information
  Widget buildLineLeaderInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: 'Line Leader Information',
      icon: Icons.person_outline,
      iconColor: AppColors.warning,
      iconBg: AppColors.warningSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.receiverFrom,
            child: Text(
              report.receivedFrom?.isNotEmpty == true
                  ? report.receivedFrom!
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
            label: l10n.storageLocation,
            child: Text(
              report.storageLocation?.isNotEmpty == true
                  ? report.storageLocation!
                  : '-',
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

  // Build Section: Production Information
  Widget buildProductionInformation(
    BuildContext context,
    WorkflowReportEntity report,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: 'Production Information',
      icon: Icons.precision_manufacturing_outlined,
      iconColor: AppColors.warning,
      iconBg: AppColors.warningSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.toWhere,
            child: Text(
              report.toWhere?.isNotEmpty == true ? report.toWhere! : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: l10n.toWho,
            child: Text(
              report.toWho?.isNotEmpty == true ? report.toWho! : '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: l10n.quantityToProduction,
            child: Text(
              report.toProductionNow?.isNotEmpty == true
                  ? report.toProductionNow!
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
            label: l10n.fromLeader,
            child: Text(
              report.fromLeader?.isNotEmpty == true ? report.fromLeader! : '-',
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
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: l10n.workflowInformation,
      icon: Icons.timeline_outlined,
      iconColor: AppColors.secondary,
      iconBg: AppColors.secondarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.currentStep,
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
            label: l10n.currentStatus,
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
            label: l10n.actionDate,
            child: Text(
              report.actionDate ?? '-',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          WorkflowComponents.buildDivider(),
          WorkflowComponents.buildInfoRow(
            label: l10n.submittedBy,
            child: Text(
              report.personName,
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
    final l10n = AppLocalizations.of(context)!;
    return WorkflowComponents.buildCard(
      title: l10n.quantityInformation,
      icon: Icons.bar_chart_outlined,
      iconColor: AppColors.success,
      iconBg: AppColors.successSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WorkflowComponents.buildInfoRow(
            label: l10n.preparedMaterialReceived,
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
          //     label: l10n.totalToProduction,
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
          //     label: l10n.currentMaterialBalance,
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
            label: l10n.difference,
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
    final l10n = AppLocalizations.of(context)!;
    if (report.lots.isEmpty) {
      return const SizedBox.shrink();
    }

    return WorkflowComponents.buildCard(
      title: l10n.lotInformation,
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
                    lot.lotName.isNotEmpty
                        ? lot.lotName
                        : '${l10n.lot} ${index + 1}',
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
    final l10n = AppLocalizations.of(context)!;
    if (report.specPictures.isEmpty) {
      return const SizedBox.shrink();
    }

    return WorkflowComponents.buildCard(
      title: l10n.specPictures,
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
