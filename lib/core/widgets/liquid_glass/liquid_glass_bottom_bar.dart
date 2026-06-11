// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_bottom_bar.dart
// المسار: core/widgets/liquid_glass/liquid_glass_bottom_bar.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • LiquidGlassBottomBar
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';
/// مكوّن واجهة: زجاجي زجاج سفلي شريط.
class LiquidGlassBottomBar extends StatelessWidget {
  /// دالة زجاجي زجاج سفلي شريط.
  const LiquidGlassBottomBar({super.key, required this.child});

  /// حقل: child.
  final Widget child;

  @override
  /// يبني شجرة الواجهة (Widget).
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
            /// دالة box shadow.
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
