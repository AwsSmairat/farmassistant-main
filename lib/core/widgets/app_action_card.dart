import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass/liquid_glass.dart';

/// Action card: frosted glass; primary uses warm orange glass tint.
class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.primary = false,
    this.onTap,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: titleStyle),
                      if (description != null) ...[
                        const SizedBox(height: 4),
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
