import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../l10n/app_localizations.dart';

/// Material request card widget for the MR listing screen.
class MrRequestCard extends StatefulWidget {
  const MrRequestCard({
    super.key,
    required this.requestNumber,
    required this.workOrder,
    required this.demandWk,
    required this.pcn,
    required this.finishGoodCtn,
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
  final String finishGoodCtn;
  final String materialPn;
  final String materialName;
  final String requestQuantity;
  final String unit;
  final String currentStatus;
  final String currentStep;
  final String requestDate;
  final VoidCallback? onTap;

  @override
  State<MrRequestCard> createState() => _MrRequestCardState();
}

class _MrRequestCardState extends State<MrRequestCard> {
  bool _isExpanded = false;

  Color get _stepColor {
    final lower = widget.currentStep.toLowerCase();
    if (lower.contains('urgent') || lower.contains('high'))
      return AppColors.error;
    if (lower.contains('medium') || lower.contains('normal'))
      return AppColors.warning;
    return AppColors.info;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
              decoration: BoxDecoration(
                border: _isExpanded
                    ? const Border(
                        bottom: BorderSide(color: AppColors.cardBorder),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.requestNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.workOrder} - ${widget.materialPn}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(label: widget.currentStatus),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            // Body
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity, height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: l10n.materialName,
                      value: widget.materialName,
                      valueMaxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.work_outline_rounded,
                      label: l10n.demandWk,
                      value: widget.demandWk,
                    ),
                    const SizedBox(height: 8),

                    _InfoRow(
                      icon: Icons.badge_outlined,
                      label: l10n.pcn,
                      value: widget.pcn,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: l10n.finishGoodCtn,
                      value: widget.finishGoodCtn,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.numbers_rounded,
                      label: l10n.quantity,
                      value: widget.requestQuantity,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.straighten_rounded,
                      label: l10n.unit,
                      value: widget.unit,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.date_range,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),

                              Text(
                                widget.requestDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _stepColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 12,
                                color: _stepColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.currentStep,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _stepColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueMaxLines = 1,
  });
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
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: valueMaxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
