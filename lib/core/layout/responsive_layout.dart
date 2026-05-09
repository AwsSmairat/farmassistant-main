import 'package:flutter/material.dart';

/// Breakpoints for web/tablet/desktop alongside narrow phones.
abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double medium = 900;
  static const double expanded = 1200;

  /// When true, use [NavigationRail] instead of bottom navigation (home shell).
  static bool useNavigationRail(double width) => width >= medium;

  static int sensorsGridCrossAxisCount(double width) {
    if (width >= expanded) return 4;
    if (width >= compact) return 3;
    return 2;
  }
}

/// Centers content on wide viewports (forms, panels). Full-width on phones.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 520,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
