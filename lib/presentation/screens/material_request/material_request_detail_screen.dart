import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/mr_request_entity.dart';

class MaterialRequestDetailScreen extends StatefulWidget {
  final MrRequestEntity?
  request; // Can be null if navigating from a place without entity

  const MaterialRequestDetailScreen({super.key, this.request});

  @override
  State<MaterialRequestDetailScreen> createState() =>
      _MaterialRequestDetailScreenState();
}

class _MaterialRequestDetailScreenState
    extends State<MaterialRequestDetailScreen> {
  final List<LotData> _lots = [LotData()];
  bool _specCheck = false;
  bool _quantityCheck = false;
  String _verifyMethod = 'Select Verify Method';
  final String _locker = 'L-00';
  final String _preparerId = 'ID';

  @override
  void dispose() {
    for (var lot in _lots) {
      lot.dispose();
    }
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
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.textPrimary,
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Floor A - Unit 4',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Text(
                  'STATUS: ',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'IN PROGRESS',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.warning,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Reject',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLotInformationCard(),
                    const SizedBox(height: 16),
                    _buildVerificationCard(),
                    const SizedBox(height: 16),
                    _buildSpecPictureCard(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildLotInformationCard() {
    return _buildCard(
      title: 'Lot Information',
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._lots.asMap().entries.map((entry) {
            final index = entry.key;
            final lot = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _lots.length - 1 ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFieldLabel('LOT NAME ${index + 1}'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: lot.nameController,
                    hint: 'Enter lot name',
                    suffixIcon: Icons.grid_on_rounded,
                    rightWidget: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          lot.dispose();
                          _lots.removeAt(index);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFieldLabel('QTY ${index + 1}'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: lot.qtyController,
                    hint: '0',
                    suffixText: '#',
                  ),
                  if (index != _lots.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Divider(color: AppColors.cardBorder, height: 1),
                    ),
                ],
              ),
            );
          }),
          _buildDashedButton(
            label: 'Add Lot',
            icon: Icons.add,
            onTap: () {
              setState(() {
                _lots.add(LotData());
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard() {
    return _buildCard(
      title: 'Verification & Info',
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.primary,
      iconBg: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFieldLabel('PREPARED QUANTITY'),
          const SizedBox(height: 6),
          _buildTextField(hint: 'Enter amount', suffixText: '#'),
          const SizedBox(height: 12),
          _buildFieldLabel('VERIFY METHOD'),
          const SizedBox(height: 6),
          _buildDropdown(
            value: _verifyMethod,
            items: ['Select Verify Method', 'Method A', 'Method B'],
            onChanged: (v) => setState(() => _verifyMethod = v!),
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('BARCODE SCAN'),
          const SizedBox(height: 6),
          _buildTextField(
            hint: 'Scan barcode',
            suffixIcon: Icons.qr_code_scanner,
            suffixIconColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('VERIFICATION CODE'),
          const SizedBox(height: 6),
          _buildTextField(
            hint: 'Input code',
            suffixIcon: Icons.security_outlined,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFieldLabel('LOCKER'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      hint: _locker,
                      suffixIcon: Icons.lock_outline,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFieldLabel('PREPARER ID'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      hint: _preparerId,
                      suffixIcon: Icons.language_outlined, // globe icon
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFieldLabel('PREPARER NAME'),
          const SizedBox(height: 6),
          _buildTextField(hint: 'Full Name', suffixIcon: Icons.person_outline),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCheckboxItem(
                  'Spec Check',
                  _specCheck,
                  (v) => setState(() => _specCheck = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCheckboxItem(
                  'Quantity\nCheck',
                  _quantityCheck,
                  (v) => setState(() => _quantityCheck = v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecPictureCard() {
    return _buildCard(
      title: 'Spec Picture',
      icon: Icons.image_outlined,
      iconColor: AppColors.secondaryLight,
      iconBg: AppColors.secondarySurface,
      child: GestureDetector(
        onTap: () {},
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: AppColors.cardBorder,
            strokeWidth: 1.5,
            dashPattern: const [6, 4],
            radius: const Radius.circular(12),
          ),
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textTertiary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ADD PHOTO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textOnPrimary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Save & Submit',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    required String hint,
    IconData? suffixIcon,
    Color? suffixIconColor,
    String? suffixText,
    VoidCallback? suffixAction,
    Widget? rightWidget,
  }) {
    Widget field = TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: suffixIconColor ?? AppColors.textTertiary,
                size: 20,
              )
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
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textTertiary,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDashedButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: AppColors.primaryBorder,
          strokeWidth: 1.5,
          dashPattern: const [6, 4],
          radius: const Radius.circular(8),
        ),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(
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
            height: 24,
            width: 24,
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
                fontSize: 13,
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

class LotData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();

  void dispose() {
    nameController.dispose();
    qtyController.dispose();
  }
}
