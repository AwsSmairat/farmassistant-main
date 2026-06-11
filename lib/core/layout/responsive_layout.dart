// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: responsive_layout.dart
// المسار: core/layout/responsive_layout.dart
// الطبقة: core / layout — التخطيط المتجاوب
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • ResponsiveCenter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

/// Breakpoints for web/tablet/desktop alongside narrow phones.
abstract final class AppBreakpoints {
  /// حقل: compact.
  static const double compact = 600;
  /// حقل: medium.
  static const double medium = 900;
  /// حقل: expanded.
  static const double expanded = 1200;

  /// When true, use [NavigationRail] instead of bottom navigation (home shell).
  /// دالة use تنقل rail.
  static bool useNavigationRail(double width) => width >= medium;

  /// دالة المستشعرات grid cross axis count.
  static int sensorsGridCrossAxisCount(double width) {
    if (width >= expanded) return 4;
    if (width >= compact) return 3;
    return 2;
  }
}
/// كلاس متجاوب center.
class ResponsiveCenter extends StatelessWidget {
  /// دالة متجاوب center.
  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 520,
  });

  /// حقل: child.
  final Widget child;
  /// حقل: max width.
  final double maxWidth;

  @override
  /// يبني شجرة الواجهة (Widget).
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
