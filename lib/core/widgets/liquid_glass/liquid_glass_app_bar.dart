import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';

/// App bar with frosted glass; keeps titles/actions standard [AppBar] behavior.
class LiquidGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LiquidGlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
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

/// Shared frosted strip for top bars (toolbar height is handled by AppBar parent).
class _LiquidGlassBarFill extends StatelessWidget {
  const _LiquidGlassBarFill();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
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
    );
  }
}
