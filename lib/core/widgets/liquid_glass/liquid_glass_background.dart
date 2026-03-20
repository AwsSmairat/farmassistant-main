import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Full-screen ambient layer: soft “liquid” glows using brand colors (no new palette).
class LiquidGlassAppBackground extends StatelessWidget {
  const LiquidGlassAppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const _LiquidAmbientLayer(),
        child,
      ],
    );
  }
}

class _LiquidAmbientLayer extends StatelessWidget {
  const _LiquidAmbientLayer();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ColoredBox(
        color: AppColors.background,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _glow(
              alignment: const Alignment(-0.85, -0.65),
              color: AppColors.primary.withValues(alpha: 0.14),
              size: 1.15,
            ),
            _glow(
              alignment: const Alignment(0.9, -0.2),
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              size: 1.0,
            ),
            _glow(
              alignment: const Alignment(-0.2, 0.85),
              color: AppColors.primaryDark.withValues(alpha: 0.11),
              size: 1.05,
            ),
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
