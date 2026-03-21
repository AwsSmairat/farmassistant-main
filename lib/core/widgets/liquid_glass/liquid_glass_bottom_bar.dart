import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';

/// Wraps [BottomNavigationBar] with frosted glass and rounded top corners.
class LiquidGlassBottomBar extends StatelessWidget {
  const LiquidGlassBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(LiquidGlassTokens.radiusLg)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: LiquidGlassTokens.blurStrong,
          sigmaY: LiquidGlassTokens.blurStrong,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surface.withValues(alpha: 0.48),
                AppColors.navBackground.withValues(alpha: 0.72),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
