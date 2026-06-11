// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_status_indicator.dart
// المسار: core/widgets/app_status_indicator.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppStatusIndicator
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
/// كلاس التطبيق الحالة مؤشر.
class AppStatusIndicator extends StatelessWidget {
  /// دالة التطبيق الحالة مؤشر.
  const AppStatusIndicator({
    super.key,
    required this.label,
    this.color = AppColors.success,
    this.dotSize = 8,
  });

  /// حقل: label.
  final String label;
  /// حقل: color.
  final Color color;
  /// حقل: نقطة size.
  final double dotSize;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
      /// دالة container.
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
            /// دالة box shadow.
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        /// دالة sized box.
        const SizedBox(width: 8),
      /// دالة نص.
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
