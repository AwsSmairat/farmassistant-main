// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_filter_chip.dart
// المسار: core/widgets/app_filter_chip.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppFilterChip
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
/// كلاس التطبيق فلتر شريحة.
class AppFilterChip extends StatelessWidget {
  /// دالة التطبيق فلتر شريحة.
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.dotColor,
  });

  /// حقل: label.
  final String label;
  /// حقل: selected.
  final bool selected;
  /// حقل: on selected.
  final ValueChanged<bool> onSelected;
  /// Optional status dot color (e.g. green for Online, blue for Charging).
  /// حقل: نقطة color.
  final Color? dotColor;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => onSelected(!selected),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dotColor != null) ...[
              /// دالة container.
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                /// دالة sized box.
                const SizedBox(width: 8),
              ],
            /// دالة نص.
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
