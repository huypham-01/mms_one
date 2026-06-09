import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/localization_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/overtime_entity.dart';
import '../../providers/overtime_provider.dart';

class MaterialOvertimeScreen extends StatefulWidget {
  const MaterialOvertimeScreen({super.key});

  @override
  State<MaterialOvertimeScreen> createState() => _MaterialOvertimeScreenState();
}

class _MaterialOvertimeScreenState extends State<MaterialOvertimeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OvertimeProvider>().loadOvertimes();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<OvertimeProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.materialOvertime,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              context.l10n.materialOvertimeSubtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<OvertimeProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () => provider.refresh(),
                  tooltip: context.l10n.refresh,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<OvertimeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null && provider.items.isEmpty) {
            return _buildError(provider);
          }

          if (provider.items.isEmpty) {
            return _buildEmpty();
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            color: AppColors.primary,
            child: Column(
              children: [
                _buildSummaryBar(provider),
                _buildTableHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        provider.items.length + (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      return _OvertimeRow(
                        item: provider.items[index],
                        isEven: index % 2 == 0,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryBar(OvertimeProvider provider) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.timer_off_rounded, size: 16, color: AppColors.error),
          const SizedBox(width: 6),
          Text(
            context.l10n.totalOvertimeItems(provider.total),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            context.l10n.pageIndicator(provider.currentPage, provider.lastPage),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.surfaceVariant,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _headerCell('PCN', flex: 3),
          _headerCell(context.l10n.requestNo, flex: 4),
          _headerCell(context.l10n.materialPn, flex: 3),
          _headerCell(context.l10n.days, flex: 2, center: true),
        ],
      ),
    );
  }

  Widget _headerCell(String label, {int flex = 2, bool center = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildError(OvertimeProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.loadOvertimes,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_off_outlined,
            size: 64,
            color: AppColors.textTertiary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.noOvertimeRecordsFound,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// ROW WIDGET
// ─────────────────────────────────────────────────────────
class _OvertimeRow extends StatefulWidget {
  final OvertimeMrEntity item;
  final bool isEven;

  const _OvertimeRow({required this.item, required this.isEven});

  @override
  State<_OvertimeRow> createState() => _OvertimeRowState();
}

class _OvertimeRowState extends State<_OvertimeRow> {
  bool _expanded = false;

  Color _daysColor(double days) {
    if (days >= 5) return AppColors.error;
    if (days >= 2) return AppColors.warning;
    return AppColors.error;
  }

  Color _daysBackground(double days) {
    if (days >= 5) return AppColors.errorSurface;
    if (days >= 2) return AppColors.warningSurface;
    return AppColors.errorSurface;
  }

  @override
  Widget build(BuildContext context) {
    final daysColor = _daysColor(widget.item.daysSinceOpen);
    final daysBg = _daysBackground(widget.item.daysSinceOpen);
    final requestDate = DateTime.parse(widget.item.requestDate);

    final dueDate = requestDate.add(const Duration(days: 3));

    final days = DateTime.now().difference(dueDate).inHours / 24.0;

    final daysLabel = days.toStringAsFixed(1);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.isEven ? AppColors.surface : AppColors.surfaceVariant,
          border: Border(
            bottom: const BorderSide(color: AppColors.divider, width: 0.5),
            left: _expanded
                ? const BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Column(
          children: [
            // ── MAIN ROW ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.item.pcn,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      widget.item.requestNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      widget.item.materialPn,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: daysBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$daysLabel ${context.l10n.dayAbbreviation}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: daysColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── EXPANDED DETAIL ──
            if (_expanded) _buildDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow(
            Icons.inventory_2_outlined,
            context.l10n.materialName,
            widget.item.materialName,
          ),
          const SizedBox(height: 10),
          _detailRow(
            Icons.calendar_today_rounded,
            context.l10n.requestDate,
            widget.item.requestDate,
          ),
          const SizedBox(height: 10),
          _detailRow(
            Icons.work_outline_rounded,
            context.l10n.currentStep,
            widget.item.currentStep,
          ),
          const SizedBox(height: 10),
          _detailRow(
            Icons.info_outline_rounded,
            context.l10n.status,
            widget.item.currentStatus,
          ),
          if (widget.item.isRejected && widget.item.rejectReason != null) ...[
            const SizedBox(height: 10),
            _detailRow(
              Icons.cancel_outlined,
              context.l10n.rejectReason,
              widget.item.rejectReason!,
              valueColor: AppColors.error,
            ),
          ],
          if (widget.item.overtimeAt != null) ...[
            const SizedBox(height: 10),
            _detailRow(
              Icons.timer_off_rounded,
              context.l10n.overtimeAt,
              widget.item.overtimeAt!,
              valueColor: AppColors.error,
            ),
          ],
          const SizedBox(height: 10),
          _detailRow(
            Icons.numbers_rounded,
            context.l10n.qty,
            '${widget.item.requestQuantity} ${widget.item.unit}',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = AppColors.textPrimary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
