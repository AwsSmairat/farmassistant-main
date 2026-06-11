// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_primary_button.dart
// المسار: core/widgets/app_primary_button.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • AppPrimaryButton
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Primary action button: solid orange background, white text, rounded corners.
/// مكوّن واجهة: التطبيق رئيسي زر.
class AppPrimaryButton extends StatelessWidget {
  /// دالة التطبيق رئيسي زر.
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon = false,
    this.isLoading = false,
    this.minWidth,
  });

  /// حقل: label.
  final String label;
  /// حقل: on pressed.
  final VoidCallback? onPressed;
  /// حقل: أيقونة.
  final IconData? icon;
  /// حقل: trailing أيقونة.
  final bool trailingIcon;
  /// حقل: is تحميل.
  final bool isLoading;
  /// حقل: min width.
  final double? minWidth;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final effectiveMinWidth = minWidth ?? double.infinity;
    return SizedBox(
      width: effectiveMinWidth,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            /// دالة sized box.
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null && !trailingIcon) ...[
                  /// دالة أيقونة.
                    Icon(icon, size: 20),
                    /// دالة sized box.
                    const SizedBox(width: 8),
                  ],
                /// دالة نص.
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  if (icon != null && trailingIcon) ...[
                    /// دالة sized box.
                    const SizedBox(width: 8),
                  /// دالة أيقونة.
                    Icon(icon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
