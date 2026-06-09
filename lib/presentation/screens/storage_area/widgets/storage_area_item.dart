import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/localization/localization_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/storage_area_entity.dart';
import '../../../../../routes/route_names.dart';

class StorageAreaItem extends StatelessWidget {
  final StorageAreaMrEntity mr;

  const StorageAreaItem({super.key, required this.mr});

  Color _getStatusColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'in use') return AppColors.success;
    if (lowerStatus == 'pending confirm') return AppColors.warning;
    if (lowerStatus == 'open') return AppColors.info;
    if (lowerStatus == 'close') return AppColors.error;
    return AppColors.textSecondary;
  }

  Color _getStatusBgColor(String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'in use') return AppColors.successSurface;
    if (lowerStatus == 'pending confirm') return AppColors.warningSurface;
    if (lowerStatus == 'open') return AppColors.infoSurface;
    if (lowerStatus == 'close') return AppColors.errorSurface;
    return AppColors.iconBackground;
  }

  String _localizedStatus(BuildContext context, String status) {
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'in use') return context.l10n.statusInUse;
    if (lowerStatus == 'pending confirm') return context.l10n.pendingConfirm;
    if (lowerStatus == 'open') return context.l10n.statusOpen;
    if (lowerStatus == 'close') return context.l10n.statusClose;
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(mr.currentStatus);
    final statusBg = _getStatusBgColor(mr.currentStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.pushNamed(
              RouteNames.transactionLog,
              pathParameters: {'mrId': mr.mrId},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${mr.requestNumber} - ${mr.materialPn}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _localizedStatus(
                          context,
                          mr.currentStatus,
                        ).toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  mr.materialName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.locker,
                        mr.locker.isNotEmpty ? mr.locker : '-',
                        isHighlight: true,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.location,
                        mr.location.isNotEmpty ? mr.location : '-',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.received,
                        mr.preparedMaterialReceived.isNotEmpty
                            ? mr.preparedMaterialReceived
                            : '-',
                        isHighlight: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.toProduct,
                        mr.totalToProduction.isNotEmpty
                            ? mr.totalToProduction
                            : '-',
                        isHighlight: true,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.balance,
                        mr.currentMaterialBalance.isNotEmpty
                            ? mr.currentMaterialBalance
                            : '-',
                        isHighlight: true,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoCol(
                        context.l10n.unit,
                        mr.unit.isNotEmpty ? mr.unit : '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${context.l10n.lastConsume}: ',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: mr.lastConsumeAt.isNotEmpty
                              ? mr.lastConsumeAt
                              : '-',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: isHighlight
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
