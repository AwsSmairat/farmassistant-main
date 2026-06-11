// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_navigation_items.dart
// المسار: core/widgets/liquid_glass/liquid_glass_navigation_items.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • LiquidGlassNavDestination
//   • LiquidGlassNavBar
//   • _LiquidGlassNavButton
//   • _GlassNavPill
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';
/// كلاس زجاجي زجاج nav destination.
class LiquidGlassNavDestination {
  /// دالة زجاجي زجاج nav destination.
  const LiquidGlassNavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: active أيقونة.
  final IconData activeIcon;
  /// حقل: label.
  final String label;
}
/// مكوّن واجهة: زجاجي زجاج nav شريط.
class LiquidGlassNavBar extends StatelessWidget {
  /// دالة زجاجي زجاج nav شريط.
  const LiquidGlassNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.selectedColor,
    this.unselectedColor,
  });

  /// حقل: destinations.
  final List<LiquidGlassNavDestination> destinations;
  /// حقل: current index.
  final int currentIndex;
  /// حقل: on destination selected.
  final ValueChanged<int> onDestinationSelected;
  /// حقل: selected color.
  final Color? selectedColor;
  /// حقل: unselected color.
  final Color? unselectedColor;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = selectedColor ?? AppColors.primary;
    final unselected = unselectedColor ?? AppColors.textSecondary;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.1,
    );

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: List.generate(destinations.length, (index) {
              final dest = destinations[index];
              final isSelected = index == currentIndex;
              /// دالة expanded.
              return Expanded(
                child: _LiquidGlassNavButton(
                  destination: dest,
                  isSelected: isSelected,
                  selectedColor: selected,
                  unselectedColor: unselected,
                  labelStyle: labelStyle,
                  onTap: () => onDestinationSelected(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// مكوّن واجهة: زجاجي زجاج nav زر.
class _LiquidGlassNavButton extends StatelessWidget {
  /// دالة داخلية: زجاجي زجاج nav زر.
  const _LiquidGlassNavButton({
    required this.destination,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.labelStyle,
    required this.onTap,
  });

  /// حقل: destination.
  final LiquidGlassNavDestination destination;
  /// حقل: is selected.
  final bool isSelected;
  /// حقل: selected color.
  final Color selectedColor;
  /// حقل: unselected color.
  final Color unselectedColor;
  /// حقل: label style.
  final TextStyle? labelStyle;
  /// حقل: on tap.
  final VoidCallback onTap;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final iconData = isSelected ? destination.activeIcon : destination.icon;
    final color = isSelected ? selectedColor : unselectedColor;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      /// دالة animated slide.
        AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          offset: isSelected ? const Offset(0, -0.12) : Offset.zero,
          child: Icon(iconData, size: 24, color: color),
        ),
        /// دالة sized box.
        const SizedBox(height: 4),
      /// دالة نص.
        Text(
          destination.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: labelStyle?.copyWith(color: color),
        ),
      ],
    );

    return Semantics(
      button: true,
      selected: isSelected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusMd),
        splashColor: selectedColor.withValues(alpha: 0.12),
        highlightColor: selectedColor.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: isSelected
                /// دالة داخلية: زجاج nav pill.
                ? _GlassNavPill(
                    key: const ValueKey('selected'),
                    child: content,
                  )
                : Padding(
                    key: const ValueKey('idle'),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: content,
                  ),
          ),
        ),
      ),
    );
  }
}
/// كلاس زجاج nav pill.
class _GlassNavPill extends StatelessWidget {
  /// دالة داخلية: زجاج nav pill.
  const _GlassNavPill({super.key, required this.child});

  /// حقل: child.
  final Widget child;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final r = LiquidGlassTokens.radiusSm + 2;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        shadows: [
        /// دالة box shadow.
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: LiquidGlassTokens.borderAlphaAccent),
              width: 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface.withValues(alpha: 0.58),
                AppColors.primary.withValues(alpha: 0.12),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: child,
          ),
        ),
      ),
    );
  }
}
