import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'liquid_glass/liquid_glass.dart';

/// Secondary button: dark surface background, white text/icon, rounded.
/// Used for "Biometric", "Hardware Key", or Google sign-in style.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.minWidth,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? minWidth;

  @override
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
                Icon(icon, size: 20, color: AppColors.textPrimary),
                const SizedBox(width: 10),
              ],
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
