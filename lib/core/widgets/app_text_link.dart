// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_text_link.dart
// المسار: core/widgets/app_text_link.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppTextLink
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
/// كلاس التطبيق نص رابط.
class AppTextLink extends StatelessWidget {
  /// دالة التطبيق نص رابط.
  const AppTextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = 14,
  });

  /// حقل: label.
  final String label;
  /// حقل: on pressed.
  final VoidCallback onPressed;
  /// حقل: font size.
  final double fontSize;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
