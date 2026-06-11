import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/log_history_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/log_history_provider.dart';

// ═════════════════════════════════════════════════════════════════════════════
// LOG HISTORY SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class LogHistoryScreen extends StatefulWidget {
  final String mrId;

  const LogHistoryScreen({super.key, required this.mrId});

  @override
  State<LogHistoryScreen> createState() => _LogHistoryScreenState();
}

class _LogHistoryScreenState extends State<LogHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LogHistoryProvider>().load(widget.mrId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<LogHistoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _LoadingState();
          }
          if (provider.hasError) {
            return _ErrorState(
              message: provider.errorMessage ?? 'Đã xảy ra lỗi.',
              onRetry: () => provider.refresh(widget.mrId),
            );
          }
          if (provider.isEmpty) {
            return _EmptyState();
          }
          return _TimelineBody(items: provider.items);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.textPrimary,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.logHistoryTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        Consumer<LogHistoryProvider>(
          builder: (context, provider, _) => IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: provider.isLoading
                ? null
                : () => provider.refresh(widget.mrId),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// TIMELINE BODY
// ═════════════════════════════════════════════════════════════════════════════

class _TimelineBody extends StatelessWidget {
  final List<LogHistoryItemEntity> items;

  const _TimelineBody({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return _TimelineItem(
          item: item,
          isFirst: index == 0,
          isLast: isLast,
          index: index,
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// TIMELINE ITEM
// ═════════════════════════════════════════════════════════════════════════════

class _TimelineItem extends StatelessWidget {
  final LogHistoryItemEntity item;
  final bool isFirst;
  final bool isLast;
  final int index;

  const _TimelineItem({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final meta = _ActionMeta.from(item.action, item.stepName);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Timeline spine ───────────────────────────────────────────────
          SizedBox(
            width: 32,
            child: Column(
              children: [
                // Top connector
                if (!isFirst)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(width: 2, color: AppColors.cardBorder),
                    ),
                  )
                else
                  const SizedBox(height: 12),

                // Dot
                _TimelineDot(color: meta.color, icon: meta.icon),

                // Bottom connector
                if (!isLast)
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Container(width: 2, color: AppColors.cardBorder),
                    ),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Card ─────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _LogCard(item: item, meta: meta),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TimelineDot extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _TimelineDot({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LOG CARD
// ═════════════════════════════════════════════════════════════════════════════

class _LogCard extends StatefulWidget {
  final LogHistoryItemEntity item;
  final _ActionMeta meta;

  const _LogCard({required this.item, required this.meta});

  @override
  State<_LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<_LogCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final meta = widget.meta;
    final hasPayload = item.payload.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                // Step badge
                if (item.stepName != null) ...[
                  _StepBadge(step: item.stepName!),
                  const SizedBox(width: 8),
                ],
                // Action label
                // Expanded(
                //   child: Text(
                //     _formatAction(item.action),
                //     style: TextStyle(
                //       fontSize: 13,
                //       fontWeight: FontWeight.w700,
                //       color: meta.color,
                //     ),
                //   ),
                // ),
                // Expand toggle
                // if (hasPayload)
                //   GestureDetector(
                //     onTap: () => setState(() => _expanded = !_expanded),
                //     child: AnimatedRotation(
                //       turns: _expanded ? 0.5 : 0,
                //       duration: const Duration(milliseconds: 200),
                //       child: const Icon(
                //         Icons.keyboard_arrow_down_rounded,
                //         size: 20,
                //         color: AppColors.textTertiary,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),

          // ── Status transition ─────────────────────────────────────────────
          if (item.fromStatus != null || item.toStatus != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
              child: _StatusTransition(
                from: item.fromStatus,
                to: item.toStatus,
              ),
            ),

          // ── Actor info ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
            child: _ActorRow(item: item),
          ),

          // ── Timestamp ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  item.createdAt ?? '—',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // ── Note ──────────────────────────────────────────────────────────
          if (item.note != null && item.note!.isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.sticky_note_2_outlined,
                    size: 13,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Payload renderer ──────────────────────────────────────────────
          // if (hasPayload && _expanded)
          //   Padding(
          //     padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          //     child: _PayloadRenderer(payload: item.payload),
          //   ),
        ],
      ),
    );
  }

  String _formatAction(String action) {
    return action
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STEP BADGE
// ═════════════════════════════════════════════════════════════════════════════

class _StepBadge extends StatelessWidget {
  final String step;

  const _StepBadge({required this.step});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (bg, fg) = _stepColors(step);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _stepLabel(step, l10n),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  String _stepLabel(String s, AppLocalizations l10n) {
    switch (s) {
      case 'planner':
        return l10n.stepPlanner;
      case 'preparer':
        return l10n.stepPreparer;
      case 'warehouse':
        return l10n.stepWarehouse;
      case 'receiver':
        return l10n.stepReceiver;
      case 'line_leader':
        return l10n.stepLineLeader;
      case 'production':
        return l10n.stepProduction;
      default:
        return s.toUpperCase();
    }
  }

  (Color bg, Color fg) _stepColors(String s) {
    switch (s) {
      case 'planner':
        return (AppColors.primary.withValues(alpha: 0.1), AppColors.primary);
      case 'preparer':
        return (
          AppColors.secondary.withValues(alpha: 0.1),
          AppColors.secondary,
        );
      case 'warehouse':
        return (AppColors.warning.withValues(alpha: 0.12), AppColors.warning);
      case 'receiver':
        return (AppColors.success.withValues(alpha: 0.1), AppColors.success);
      case 'line_leader':
        return (
          const Color(0xFF7C3AED).withValues(alpha: 0.1),
          const Color(0xFF7C3AED),
        );
      default:
        return (
          AppColors.textTertiary.withValues(alpha: 0.1),
          AppColors.textTertiary,
        );
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STATUS TRANSITION
// ═════════════════════════════════════════════════════════════════════════════

class _StatusTransition extends StatelessWidget {
  final String? from;
  final String? to;

  const _StatusTransition({this.from, this.to});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (from != null)
          _StatusChip(label: from!, dimmed: true)
        else
          const _StatusChip(label: '—', dimmed: true),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 13,
            color: AppColors.textTertiary,
          ),
        ),
        if (to != null)
          _StatusChip(label: to!, dimmed: false)
        else
          const _StatusChip(label: '—', dimmed: true),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool dimmed;

  const _StatusChip({required this.label, required this.dimmed});

  @override
  Widget build(BuildContext context) {
    final color = dimmed ? AppColors.textTertiary : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ACTOR ROW
// ═════════════════════════════════════════════════════════════════════════════

class _ActorRow extends StatelessWidget {
  final LogHistoryItemEntity item;

  const _ActorRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = item.actorName ?? l10n.systemActor;
    final role = item.actorRole;

    return Row(
      children: [
        const Icon(
          Icons.person_outline_rounded,
          size: 13,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (role != null)
                  TextSpan(
                    text: ' · ${_roleLabel(role, l10n)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _roleLabel(String role, AppLocalizations l10n) {
    switch (role) {
      case 'planner':
        return l10n.rolePlanner;
      case 'preparer':
        return l10n.rolePreparer;
      case 'warehouse':
        return l10n.roleWarehouse;
      case 'receiver':
        return l10n.roleReceiver;
      case 'line_leader':
        return l10n.roleLineLeader;
      default:
        return role;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SMART PAYLOAD RENDERER
// ═════════════════════════════════════════════════════════════════════════════

class _PayloadRenderer extends StatelessWidget {
  final Map<String, Object?> payload;

  const _PayloadRenderer({required this.payload});

  @override
  Widget build(BuildContext context) {
    if (payload.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
            child: Consumer<LogHistoryProvider>(
              builder: (context, _, __) => Text(
                AppLocalizations.of(context)!.payloadHeader,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: payload.entries
                  .map(
                    (e) => _PayloadRow(
                      key: ValueKey(e.key),
                      label: e.key,
                      value: e.value,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PayloadRow extends StatelessWidget {
  final String label;
  final Object? value;

  const _PayloadRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final displayLabel = label
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');

    // Nested map → recursive section
    if (value is Map) {
      return _NestedPayload(
        label: displayLabel,
        data: Map<String, Object?>.from(
          (value as Map).map((k, v) => MapEntry(k.toString(), v as Object?)),
        ),
      );
    }

    // List → joined or nested
    if (value is List) {
      return _ListPayload(label: displayLabel, data: value as List<Object?>);
    }

    // Null / empty string → dash
    final displayValue = value == null || value.toString().isEmpty
        ? '—'
        : value.toString();

    final isBoolean = value is bool;
    final isWarning =
        displayValue.contains('missing') ||
        displayValue.contains('mismatch') ||
        displayValue.contains('chưa khai báo');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              displayLabel,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: isBoolean
                ? _BoolChip(value: value as bool)
                : Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isWarning
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BoolChip extends StatelessWidget {
  final bool value;

  const _BoolChip({required this.value});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: (value ? AppColors.success : AppColors.error).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value ? l10n.boolTrue : l10n.boolFalse,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: value ? AppColors.success : AppColors.error,
        ),
      ),
    );
  }
}

class _NestedPayload extends StatelessWidget {
  final String label;
  final Map<String, Object?> data;

  const _NestedPayload({required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _PayloadRow(label: label, value: null);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: data.entries
                  .map(
                    (e) => _PayloadRow(
                      key: ValueKey(e.key),
                      label: e.key,
                      value: e.value,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListPayload extends StatelessWidget {
  final String label;
  final List<Object?> data;

  const _ListPayload({required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label (${data.length})',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          ...data.asMap().entries.map((e) {
            final v = e.value;
            if (v is Map) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _NestedPayload(
                  label: '#${e.key + 1}',
                  data: Map<String, Object?>.from(
                    v.map((k, val) => MapEntry(k.toString(), val as Object?)),
                  ),
                ),
              );
            }
            return _PayloadRow(label: '#${e.key + 1}', value: v);
          }),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ACTION META (icon + color mapping)
// ═════════════════════════════════════════════════════════════════════════════

class _ActionMeta {
  final Color color;
  final IconData icon;

  const _ActionMeta({required this.color, required this.icon});

  factory _ActionMeta.from(String action, String? step) {
    if (action.contains('created') || action.contains('import')) {
      return const _ActionMeta(
        color: AppColors.primary,
        icon: Icons.add_circle_outline_rounded,
      );
    }
    if (action.contains('submitted')) {
      return const _ActionMeta(
        color: AppColors.success,
        icon: Icons.check_circle_outline_rounded,
      );
    }
    if (action.contains('rejected') || action.contains('reject')) {
      return const _ActionMeta(
        color: AppColors.error,
        icon: Icons.cancel_outlined,
      );
    }
    if (action.contains('warning') || action.contains('mismatch')) {
      return const _ActionMeta(
        color: AppColors.warning,
        icon: Icons.warning_amber_rounded,
      );
    }
    if (action.contains('blocked')) {
      return const _ActionMeta(
        color: AppColors.error,
        icon: Icons.block_rounded,
      );
    }
    if (action.contains('unblocked') || action.contains('active')) {
      return const _ActionMeta(
        color: AppColors.success,
        icon: Icons.lock_open_rounded,
      );
    }
    if (action.contains('auto')) {
      return const _ActionMeta(
        color: AppColors.secondary,
        icon: Icons.auto_mode_rounded,
      );
    }
    if (action.contains('verification')) {
      return const _ActionMeta(
        color: AppColors.secondary,
        icon: Icons.verified_outlined,
      );
    }
    if (action.contains('completed') || action.contains('done')) {
      return const _ActionMeta(
        color: AppColors.success,
        icon: Icons.task_alt_rounded,
      );
    }
    // default
    return const _ActionMeta(
      color: AppColors.textSecondary,
      icon: Icons.history_rounded,
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LOADING STATE
// ═════════════════════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: 5,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonBox(width: 36, height: 36, radius: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBox(width: double.infinity, height: 16, radius: 6),
                  const SizedBox(height: 6),
                  _SkeletonBox(width: 180, height: 12, radius: 6),
                  const SizedBox(height: 6),
                  _SkeletonBox(width: 120, height: 12, radius: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.4,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.cardBorder.withValues(alpha: _anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ERROR STATE
// ═════════════════════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadHistory,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                l10n.retryButton,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.emptyHistoryTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptyHistoryDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
