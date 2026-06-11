// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_header.dart
// المسار: core/widgets/app_header.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppHeader
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// App header: optional logo, title (with optional accent part), and subtitle.
/// كلاس التطبيق رأس.
class AppHeader extends StatelessWidget {
  /// دالة التطبيق رأس.
  const AppHeader({
    super.key,
    this.logo,
    required this.title,
    this.titleAccent,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  /// Optional widget (e.g. CircleAvatar with icon).
  /// حقل: logo.
  final Widget? logo;
  /// Main title text (displayed in white if [titleAccent] is set, else full title).
  /// حقل: title.
  final String title;
  /// Optional part of title in primary color (e.g. "AgriPulse").
  /// حقل: title accent.
  final String? titleAccent;
  /// Subtitle below title.
  /// حقل: subtitle.
  final String? subtitle;
  /// حقل: title style.
  final TextStyle? titleStyle;
  /// حقل: subtitle style.
  final TextStyle? subtitleStyle;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logo != null) ...[
          logo!,
          /// دالة sized box.
          const SizedBox(height: 16),
        ],
      /// دالة صف.
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (titleAccent != null) ...[
            /// دالة نص.
              Text(
                titleAccent!,
                style: (titleStyle ?? const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
              ),
            /// دالة نص.
              Text(
                title,
                style: titleStyle ?? const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
            /// دالة نص.
              Text(
                title,
                style: titleStyle ?? const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          /// دالة sized box.
          const SizedBox(height: 6),
        /// دالة نص.
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: subtitleStyle ?? const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
