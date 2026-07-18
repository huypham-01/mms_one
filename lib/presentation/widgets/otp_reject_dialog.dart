import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/localization_extensions.dart';
import '../../core/theme/app_colors.dart';

// ── Workflow Step Enum ─────────────────────────────────────────────────────────

/// Các bước trong workflow theo thứ tự.
enum WorkflowStep {
  preparer,
  warehouse,
  receiver,
  // ignore: constant_identifier_names
  line_leader,
  production;

  /// Tên hiển thị trên UI.
  String displayName(BuildContext context) {
    switch (this) {
      case WorkflowStep.preparer:
        return context.l10n.preparer;
      case WorkflowStep.warehouse:
        return context.l10n.warehouse;
      case WorkflowStep.receiver:
        return context.l10n.receiver;
      case WorkflowStep.line_leader:
        return context.l10n.lineLeader;
      case WorkflowStep.production:
        return context.l10n.production;
    }
  }

  /// Bước trước đó trong workflow. Trả về null nếu đây là bước đầu tiên.
  WorkflowStep? get previousStep {
    final steps = WorkflowStep.values;
    final idx = steps.indexOf(this);
    if (idx <= 0) return null;
    return steps[idx - 1];
  }

  /// Parse từ string key (e.g. 'line_leader' → WorkflowStep.line_leader).
  static WorkflowStep? fromKey(String key) {
    try {
      return WorkflowStep.values.firstWhere((e) => e.name == key);
    } catch (_) {
      return null;
    }
  }
}

// ── Result Model ──────────────────────────────────────────────────────────────

/// Kết quả trả về khi người dùng xác nhận reject.
class RejectResult {
  final String otp;
  final String? rejectReason;

  const RejectResult({required this.otp, this.rejectReason});
}

// ── Dialog ────────────────────────────────────────────────────────────────────

/// Dialog Reject Current Step.
///
/// Chỉ cần truyền [currentStep], dialog tự tính bước trước đó.
///
/// ```dart
/// final result = await OtpRejectDialog.show(
///   context,
///   currentStep: WorkflowStep.receiver,
/// );
/// ```
///
/// Hoặc dùng string key:
/// ```dart
/// final result = await OtpRejectDialog.showByKey(
///   context,
///   stepKey: 'receiver',
/// );
/// ```
class OtpRejectDialog extends StatefulWidget {
  final WorkflowStep currentStep;

  const OtpRejectDialog({super.key, required this.currentStep});

  /// Hiển thị dialog với [WorkflowStep] enum.
  static Future<RejectResult?> show(
    BuildContext context, {
    required WorkflowStep currentStep,
  }) {
    return showDialog<RejectResult>(
      context: context,
      barrierDismissible: false,
      // useRootNavigator + useSafeArea false để tự kiểm soát layout
      useRootNavigator: true,
      builder: (ctx) =>
          _RejectDialogShell(child: OtpRejectDialog(currentStep: currentStep)),
    );
  }

  /// Hiển thị dialog với string key: 'preparer' | 'warehouse' | 'receiver' | 'line_leader' | 'production'.
  /// Trả về null ngay nếu key không hợp lệ.
  static Future<RejectResult?> showByKey(
    BuildContext context, {
    required String stepKey,
  }) {
    final step = WorkflowStep.fromKey(stepKey);
    if (step == null) return Future.value(null);
    return show(context, currentStep: step);
  }

  @override
  State<OtpRejectDialog> createState() => _OtpRejectDialogState();
}

class _OtpRejectDialogState extends State<OtpRejectDialog> {
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _reasonCtrl = TextEditingController();
  String? _otpError;

  // Tính toán bước trước một lần duy nhất
  late final WorkflowStep? _prevStep = widget.currentStep.previousStep;

  @override
  void initState() {
    super.initState();
    _otpCtrl.addListener(() {
      if (_otpError != null) setState(() => _otpError = null);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  String get _otpValue => _otpCtrl.text;

  void _onConfirm() {
    final otp = _otpValue.trim();
    if (otp.length != 6) {
      setState(() => _otpError = context.l10n.enterAllOtpDigits);
      return;
    }
    Navigator.of(context).pop(
      RejectResult(
        otp: otp,
        rejectReason: _reasonCtrl.text.trim().isEmpty
            ? null
            : _reasonCtrl.text.trim(),
      ),
    );
  }

  void _onCancel() => Navigator.of(context).pop(null);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildHeader(), _buildBody()],
          ),
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(bottom: BorderSide(color: Colors.red.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Icon(
              Icons.history_rounded,
              color: Colors.red.shade400,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.l10n.rejectCurrentStep,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStepIndicator(),
          const SizedBox(height: 20),
          _buildSectionLabel(context.l10n.rejectReason),
          const SizedBox(height: 8),
          _buildReasonField(),
          const SizedBox(height: 20),
          _buildOtpHeader(),
          const SizedBox(height: 10),
          _buildOtpRow(),
          if (_otpError != null) ...[
            const SizedBox(height: 6),
            Text(
              _otpError!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildButtons(),
        ],
      ),
    );
  }

  // ── Step Indicator ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    final current = widget.currentStep;
    final prev = _prevStep;

    // Mô tả động theo bước
    final description = prev != null
        ? context.l10n.returnToPreviousStep(prev.displayName(context))
        : context.l10n.firstStepCannotReturnFurther;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Bước trước — filled dark (hoặc placeholder nếu là bước đầu)
              _stepPill(
                label: current.displayName(context),
                filled: true,
                disabled: prev == null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ),
              // Bước hiện tại — outlined red
              _stepPill(
                label: prev?.displayName(context) ?? '—',
                filled: false,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepPill({
    required String label,
    required bool filled,
    bool disabled = false,
  }) {
    if (filled) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade300 : const Color(0xFF1A2B5E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: disabled ? Colors.grey.shade500 : Colors.white,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300, width: 1.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.red.shade500,
        ),
      ),
    );
  }

  // ── Common ─────────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3A3A4C),
      ),
    );
  }

  Widget _buildOtpHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel(context.l10n.supervisorOtp),
        TextButton(
          onPressed: () async {
            final Uri uri = Uri(scheme: 'myotpapp', host: 'generate');
            try {
              final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalNonBrowserApplication,
              );
              if (!launched && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Không thể mở app OTP. Vui lòng kiểm tra đã cài đặt chưa.',
                    ),
                  ),
                );
              }
            } catch (_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Không thể mở app OTP. Vui lòng kiểm tra đã cài đặt chưa.',
                    ),
                  ),
                );
              }
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Get OTP', style: TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildReasonField() {
    return TextField(
      controller: _reasonCtrl,
      maxLines: 3,
      minLines: 3,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: context.l10n.enterRejectReason,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E4EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E4EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A2B5E), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildOtpRow() {
    final hasError = _otpError != null;
    return TextField(
      controller: _otpCtrl,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 12,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: '------',
        hintStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 12,
          color: Colors.grey.shade300,
        ),
        filled: true,
        fillColor: hasError
            ? Colors.red.shade50
            : _otpCtrl.text.isNotEmpty
                ? const Color(0xFFF0F3FF)
                : const Color(0xFFF8F9FC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red.shade400 : const Color(0xFFDDE1EE),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red.shade400 : const Color(0xFFDDE1EE),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red.shade500 : const Color(0xFF1A2B5E),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5A5A72),
              side: const BorderSide(color: Color(0xFFDDE1EE), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              context.l10n.cancel,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              context.l10n.confirmReject,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}



// ── Shell: giải quyết keyboard resize chuẩn production ────────────────────────
//
// Vấn đề: Dialog mặc định của Flutter dùng [_DialogRoute] với Overlay,
// không được resize khi bàn phím xuất hiện vì nó nằm ngoài Scaffold.
//
// Giải pháp: Bọc content trong một Scaffold trong suốt với
// [resizeToAvoidBottomInset: true]. Scaffold này rebuild đúng
// [viewInsets] → dialog tự đẩy lên khi bàn phím hiện mà không
// bị co nhỏ hay overflow.
class _RejectDialogShell extends StatelessWidget {
  final Widget child;
  const _RejectDialogShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Trong suốt hoàn toàn — chỉ dùng Scaffold để nhận viewInsets
      backgroundColor: Colors.transparent,
      // Bàn phím đẩy nội dung lên thay vì đè lên
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        // Nhấn vùng tối ngoài dialog → ẩn bàn phím
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ),
    );
  }
}
