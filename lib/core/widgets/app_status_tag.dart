// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_status_tag.dart
// المسار: core/widgets/app_status_tag.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppStatusTag
//   • enum AppStatusTagVariant
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
/// كلاس التطبيق الحالة وسم.
class AppStatusTag extends StatelessWidget {
  /// دالة التطبيق الحالة وسم.
  const AppStatusTag({
    super.key,
    required this.label,
    this.variant = AppStatusTagVariant.success,
  });

  /// حقل: label.
  final String label;
  /// حقل: variant.
  final AppStatusTagVariant variant;

  /// دالة داخلية: color for.
  static Color _colorFor(AppStatusTagVariant v) {
  /// دالة switch.
    switch (v) {
      case AppStatusTagVariant.success:
        return AppColors.success;
      case AppStatusTagVariant.error:
        return AppColors.error;
      case AppStatusTagVariant.warning:
        return AppColors.warning;
      case AppStatusTagVariant.info:
        return AppColors.info;
    }
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final color = _colorFor(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// تعداد التطبيق الحالة وسم variant.
enum AppStatusTagVariant { success, error, warning, info }
