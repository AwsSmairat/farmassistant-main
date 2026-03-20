import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';

/// Frosted glass panel. Optional [accentBorder] tints the edge (e.g. sensor health).
class LiquidGlassPanel extends StatelessWidget {
  const LiquidGlassPanel({
    super.key,
    required this.child,
    this.borderRadius = LiquidGlassTokens.radiusMd,
    this.padding,
    this.blurSigma = LiquidGlassTokens.blurMedium,
    this.accentBorder,
    this.accentBorderWidth = 1,
    this.gradientColors,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;
  final Color? accentBorder;
  final double accentBorderWidth;
  /// When set, overrides the default frosted surface gradient.
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final borderColor = accentBorder != null
        ? accentBorder!.withValues(alpha: 0.38)
        : AppColors.primary.withValues(alpha: LiquidGlassTokens.borderAlpha);

    final gradient = gradientColors != null && gradientColors!.length >= 2
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors!,
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface.withValues(alpha: LiquidGlassTokens.fillAlphaSurface),
              AppColors.surfaceVariant.withValues(alpha: LiquidGlassTokens.fillAlphaVariant),
            ],
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: accentBorderWidth),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}
