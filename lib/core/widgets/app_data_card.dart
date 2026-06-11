// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_data_card.dart
// المسار: core/widgets/app_data_card.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • AppDataCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass/liquid_glass.dart';
/// مكوّن واجهة: التطبيق بيانات بطاقة.
class AppDataCard extends StatelessWidget {
  /// دالة التطبيق بيانات بطاقة.
  const AppDataCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor = AppColors.primary,
    this.trend,
    this.trendPositive = true,
    this.statusLabel,
    this.onTap,
  });

  /// حقل: label.
  final String label;
  /// حقل: value.
  final String value;
  /// حقل: أيقونة.
  final IconData? icon;
  /// حقل: أيقونة color.
  final Color iconColor;
  /// e.g. "+2%" or "-5%"
  /// حقل: trend.
  final String? trend;
  /// حقل: trend positive.
  final bool trendPositive;
  /// e.g. "Stable"
  /// حقل: الحالة label.
  final String? statusLabel;
  /// حقل: on tap.
  final VoidCallback? onTap;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
            /// دالة صف.
              Row(
                children: [
                  if (icon != null) ...[
                  /// دالة container.
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    /// دالة sized box.
                    const SizedBox(width: 12),
                  ],
                /// دالة expanded.
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (trend != null)
                  /// دالة نص.
                    Text(
                      trend!,
                      style: TextStyle(
                        color: trendPositive ? AppColors.success : AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  /// دالة if.
                  else if (statusLabel != null)
                  /// دالة نص.
                    Text(
                      statusLabel!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              /// دالة sized box.
              const SizedBox(height: 8),
            /// دالة نص.
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
