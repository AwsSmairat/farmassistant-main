// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_app_bar.dart
// المسار: core/widgets/liquid_glass/liquid_glass_app_bar.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • LiquidGlassAppBar
//   • _LiquidGlassBarFill
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';
/// مكوّن واجهة: زجاجي زجاج التطبيق شريط.
class LiquidGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// دالة زجاجي زجاج التطبيق شريط.
  const LiquidGlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
  });

  /// حقل: title.
  final Widget title;
  /// حقل: actions.
  final List<Widget>? actions;
  /// حقل: leading.
  final Widget? leading;
  /// حقل: automatically imply leading.
  final bool automaticallyImplyLeading;
  /// حقل: center title.
  final bool centerTitle;

  @override
  /// يُرجع preferred size.
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: const _LiquidGlassBarFill(),
    );
  }
}
/// كلاس زجاجي زجاج شريط fill.
class _LiquidGlassBarFill extends StatelessWidget {
  /// دالة داخلية: زجاجي زجاج شريط fill.
  const _LiquidGlassBarFill();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: LiquidGlassTokens.blurStrong,
            sigmaY: LiquidGlassTokens.blurStrong,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface.withValues(alpha: 0.52),
                  AppColors.surfaceVariant.withValues(alpha: 0.4),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary.withValues(alpha: LiquidGlassTokens.borderAlphaAccent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
