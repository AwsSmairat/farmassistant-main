// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_background.dart
// المسار: core/widgets/liquid_glass/liquid_glass_background.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • LiquidGlassAppBackground
//   • _LiquidAmbientLayer
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
/// كلاس زجاجي زجاج التطبيق خلفية.
class LiquidGlassAppBackground extends StatelessWidget {
  /// دالة زجاجي زجاج التطبيق خلفية.
  const LiquidGlassAppBackground({super.key, required this.child});

  /// حقل: child.
  final Widget child;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// دالة داخلية: زجاجي ambient layer.
        const _LiquidAmbientLayer(),
        child,
      ],
    );
  }
}

/// كلاس زجاجي ambient layer.
class _LiquidAmbientLayer extends StatelessWidget {
  /// دالة داخلية: زجاجي ambient layer.
  const _LiquidAmbientLayer();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColoredBox(
        color: AppColors.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
          /// دالة داخلية: glow.
            _glow(
              alignment: const Alignment(-0.85, -0.65),
              color: AppColors.primary.withValues(alpha: 0.14),
              size: 1.15,
            ),
          /// دالة داخلية: glow.
            _glow(
              alignment: const Alignment(0.9, -0.2),
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              size: 1.0,
            ),
          /// دالة داخلية: glow.
            _glow(
              alignment: const Alignment(-0.2, 0.85),
              color: AppColors.primaryDark.withValues(alpha: 0.11),
              size: 1.05,
            ),
          /// دالة داخلية: glow.
            _glow(
              alignment: const Alignment(0.65, 0.75),
              color: AppColors.accentPurple.withValues(alpha: 0.07),
              size: 0.95,
            ),
          ],
        ),
      ),
    );
  }

  /// دالة داخلية: glow.
  Widget _glow({
    required Alignment alignment,
    required Color color,
    required double size,
  }) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: 320 * size,
          height: 320 * size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
