import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable status chip widget for displaying states like
/// "Approved", "Pending", "Rejected", "In Progress", etc.
///
/// Automatically maps common status strings to colors.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.fontSize = 11,
  });

  final String label;
  final Color? color;
  final IconData? icon;
  final double fontSize;

  /// Returns a color based on common status keywords.
  Color get _resolvedColor {
    if (color != null) return color!;

    final lower = label.toLowerCase();
    if (lower.contains('approved') ||
        lower.contains('done') ||
        lower.contains('complete')) {
      return AppColors.success;
    }
    if (lower.contains('pending') ||
        lower.contains('waiting') ||
        lower.contains('review')) {
      return AppColors.warning;
    }
    if (lower.contains('rejected') ||
        lower.contains('cancel') ||
        lower.contains('error')) {
      return AppColors.error;
    }
    if (lower.contains('progress') ||
        lower.contains('active') ||
        lower.contains('processing')) {
      return AppColors.info;
    }
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = _resolvedColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: chipColor),
            const SizedBox(width: 4),
          ],
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}
