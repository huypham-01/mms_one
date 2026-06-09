import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WorkflowReportComponents {
  // ---------------------------------------------------------------------------
  // REUSABLE CARD
  // ---------------------------------------------------------------------------
  static Widget buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Widget child,
    Widget? headerAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (headerAction != null) headerAction,
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FIELD LABEL
  // ---------------------------------------------------------------------------
  static Widget buildFieldLabel(String label, {bool required = false}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),

          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT FIELD
  // ---------------------------------------------------------------------------
  static Widget buildTextField({
    TextEditingController? controller,
    required String hint,
    IconData? suffixIcon,
    Color? suffixIconColor,
    String? suffixText,
    Widget? rightWidget,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTapSuffix,
  }) {
    Widget field = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon != null
            ? (onTapSuffix != null
                  ? InkWell(
                      onTap: onTapSuffix,
                      child: Icon(
                        suffixIcon,
                        color: suffixIconColor ?? AppColors.textTertiary,
                        size: 20,
                      ),
                    )
                  : Icon(
                      suffixIcon,
                      color: suffixIconColor ?? AppColors.textTertiary,
                      size: 20,
                    ))
            : (suffixText != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        suffixText,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : null),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: readOnly ? AppColors.surfaceVariant : AppColors.surface,
        border: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),

        enabledBorder: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
        focusedBorder: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
      ),
    );

    if (rightWidget != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: field),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.errorSurface),
              boxShadow: const [
                BoxShadow(color: AppColors.shadowLight, blurRadius: 4),
              ],
            ),
            child: rightWidget,
          ),
        ],
      );
    }
    return field;
  }

  // ---------------------------------------------------------------------------
  // INFO ROW
  // ---------------------------------------------------------------------------
  static Widget buildInfoRow({
    required String label,
    required Widget child,
    bool required = false,
    bool labelBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: labelBold ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIVIDER
  // ---------------------------------------------------------------------------
  static Widget buildDivider() =>
      const Divider(height: 1, color: AppColors.cardBorder);

  // ---------------------------------------------------------------------------
  // READ ONLY FIELD
  // ---------------------------------------------------------------------------
  static Widget buildReadOnlyField(
    TextEditingController ctrl,
    String placeholder,
  ) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: ctrl,
      builder: (_, val, __) => Text(
        val.text.isEmpty ? placeholder : val.text,
        style: TextStyle(
          fontSize: 14,
          color: val.text.isEmpty
              ? AppColors.textTertiary
              : AppColors.textPrimary,
          fontWeight: val.text.isEmpty ? FontWeight.w400 : FontWeight.w600,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHECKBOX ITEM
  // ---------------------------------------------------------------------------
  static Widget buildCheckboxItem(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 26,
            width: 26,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.textTertiary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
