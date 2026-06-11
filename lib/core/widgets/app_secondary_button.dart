// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_secondary_button.dart
// المسار: core/widgets/app_secondary_button.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • AppSecondaryButton
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass/liquid_glass.dart';

/// Secondary button: dark surface background, white text/icon, rounded.
/// مكوّن واجهة: التطبيق ثانوي زر.
class AppSecondaryButton extends StatelessWidget {
  /// دالة التطبيق ثانوي زر.
  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.minWidth,
  });

  /// حقل: label.
  final String label;
  /// حقل: on pressed.
  final VoidCallback? onPressed;
  /// حقل: أيقونة.
  final IconData? icon;
  /// حقل: min width.
  final double? minWidth;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return SizedBox(
      width: minWidth ?? double.infinity,
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.textPrimary,
            side: BorderSide(color: AppColors.border.withValues(alpha: 0.65)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusSm),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
              /// دالة أيقونة.
                Icon(icon, size: 20, color: AppColors.textPrimary),
                /// دالة sized box.
                const SizedBox(width: 10),
              ],
            /// دالة نص.
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
