import 'package:flutter/material.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../robot/presentation/pages/robot_control_page.dart';
import '../../../sensors/presentation/pages/sensors_page.dart';
import 'dashboard_page.dart';

/// Authenticated home shell: bottom nav on phones, [NavigationRail] on wider web/tablet.
class HomeShellPage extends StatefulWidget {
  const HomeShellPage({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  late int _currentIndex;

  static const int _robotTabIndex = 2;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  @override
  void didUpdateWidget(HomeShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex.clamp(0, 4);
    }
  }

  List<Widget> _pages({required void Function() onNavigateToRobot}) {
    return [
      DashboardPage(onNavigateToRobotControl: onNavigateToRobot),
      const SensorsPage(),
      const RobotControlPage(showBackButton: false),
      const NotificationsPage(),
      const ProfilePage(),
    ];
  }

  static const _destinations = [
    LiquidGlassNavDestination(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'الرئيسية',
    ),
    LiquidGlassNavDestination(
      icon: Icons.sensors_outlined,
      activeIcon: Icons.sensors,
      label: 'المستشعرات',
    ),
    LiquidGlassNavDestination(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy,
      label: 'الروبوت',
    ),
    LiquidGlassNavDestination(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'التنبيهات',
    ),
    LiquidGlassNavDestination(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'الملف',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = AppBreakpoints.useNavigationRail(constraints.maxWidth);
        final pages = _pages(
          onNavigateToRobot: () => setState(() => _currentIndex = _robotTabIndex),
        );

        if (!wide) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
            bottomNavigationBar: LiquidGlassBottomBar(
              child: LiquidGlassNavBar(
                currentIndex: _currentIndex,
                onDestinationSelected: (index) => setState(() => _currentIndex = index),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.textSecondary,
                destinations: _destinations,
              ),
            ),
          );
        }

        final expandedRail = constraints.maxWidth >= AppBreakpoints.expanded;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavigationRail(
                extended: expandedRail,
                backgroundColor: AppColors.navBackground.withValues(alpha: 0.92),
                selectedIndex: _currentIndex,
                onDestinationSelected: (i) => setState(() => _currentIndex = i),
                // Material constraint: [extended] requires [labelType] == none
                // (labels sit beside icons when extended).
                labelType: expandedRail
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.selected,
                indicatorColor: AppColors.primary.withValues(alpha: 0.22),
                selectedIconTheme: const IconThemeData(color: AppColors.primary),
                unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary),
                selectedLabelTextStyle: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                destinations: [
                  for (var i = 0; i < _destinations.length; i++)
                    NavigationRailDestination(
                      icon: Icon(_destinations[i].icon),
                      selectedIcon: Icon(_destinations[i].activeIcon),
                      label: Text(_destinations[i].label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1, color: AppColors.border),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, inner) {
                    final maxContent = inner.maxWidth >= AppBreakpoints.expanded
                        ? AppBreakpoints.expanded
                        : inner.maxWidth;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContent),
                        child: IndexedStack(
                          index: _currentIndex,
                          children: pages,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
