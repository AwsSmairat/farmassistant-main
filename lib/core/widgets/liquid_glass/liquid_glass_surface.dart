// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_surface.dart
// المسار: core/widgets/liquid_glass/liquid_glass_surface.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • LiquidGlassPanel
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';
/// كلاس زجاجي زجاج لوحة.
class LiquidGlassPanel extends StatelessWidget {
  /// دالة زجاجي زجاج لوحة.
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

  /// حقل: child.
  final Widget child;
  /// حقل: border radius.
  final double borderRadius;
  /// حقل: padding.
  final EdgeInsetsGeometry? padding;
  /// حقل: blur sigma.
  final double blurSigma;
  /// حقل: accent border.
  final Color? accentBorder;
  /// حقل: accent border width.
  final double accentBorderWidth;
  /// When set, overrides the default frosted surface gradient.
  /// حقل: gradient الألوان.
  final List<Color>? gradientColors;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final borderColor = accentBorder != null
        ? accentBorder!.withValues(alpha: 0.38)
        : AppColors.primary.withValues(alpha: LiquidGlassTokens.borderAlpha);

    final gradient = gradientColors != null && gradientColors!.length >= 2
        /// دالة linear gradient.
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
            /// دالة box shadow.
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
