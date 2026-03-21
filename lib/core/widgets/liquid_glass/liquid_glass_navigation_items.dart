import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'liquid_glass_tokens.dart';

/// Single tab: icon + label, with optional frosted-glass pill when selected.
class LiquidGlassNavDestination {
  const LiquidGlassNavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Bottom navigation row with per-item frosted glass highlight on the active tab.
class LiquidGlassNavBar extends StatelessWidget {
  const LiquidGlassNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onDestinationSelected,
    this.selectedColor,
    this.unselectedColor,
  });

  final List<LiquidGlassNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
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

class _LiquidGlassNavButton extends StatelessWidget {
  const _LiquidGlassNavButton({
    required this.destination,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.labelStyle,
    required this.onTap,
  });

  final LiquidGlassNavDestination destination;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconData = isSelected ? destination.activeIcon : destination.icon;
    final color = isSelected ? selectedColor : unselectedColor;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          offset: isSelected ? const Offset(0, -0.12) : Offset.zero,
          child: Icon(iconData, size: 24, color: color),
        ),
        const SizedBox(height: 4),
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

/// Frosted look without extra [BackdropFilter] (bar already blurs behind).
class _GlassNavPill extends StatelessWidget {
  const _GlassNavPill({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = LiquidGlassTokens.radiusSm + 2;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        shadows: [
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
