// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_action_card.dart
// المسار: core/widgets/app_action_card.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • AppActionCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass/liquid_glass.dart';
/// مكوّن واجهة: التطبيق إجراء بطاقة.
class AppActionCard extends StatelessWidget {
  /// دالة التطبيق إجراء بطاقة.
  const AppActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.primary = false,
    this.onTap,
  });

  /// حقل: title.
  final String title;
  /// حقل: description.
  final String? description;
  /// حقل: أيقونة.
  final IconData? icon;
  /// حقل: رئيسي.
  final bool primary;
  /// حقل: on tap.
  final VoidCallback? onTap;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: primary ? AppColors.textOnPrimary : AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final descStyle = TextStyle(
      color: primary
          ? AppColors.textOnPrimary.withValues(alpha: 0.85)
          : AppColors.textSecondary,
      fontSize: 12,
    );
    final iconColor = primary ? AppColors.textOnPrimary : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurMedium,
        accentBorder: primary ? AppColors.primaryLight : null,
        gradientColors: primary
            ? [
                AppColors.primary.withValues(alpha: 0.52),
                AppColors.primaryDark.withValues(alpha: 0.42),
              ]
            : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
              /// دالة expanded.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    /// دالة نص.
                      Text(title, style: titleStyle),
                      if (description != null) ...[
                        /// دالة sized box.
                        const SizedBox(height: 4),
                      /// دالة نص.
                        Text(description!, style: descStyle),
                      ],
                    ],
                  ),
                ),
                if (icon != null) Icon(icon, color: iconColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
