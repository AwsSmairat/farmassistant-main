import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../robot/presentation/pages/robot_control_page.dart';
import '../../../sensors/presentation/pages/sensors_page.dart';
import 'dashboard_page.dart';

/// Authenticated home shell: bottom nav with 5 tabs, IndexedStack to preserve state.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            onNavigateToRobotControl: () =>
                setState(() => _currentIndex = _robotTabIndex),
          ),
          const SensorsPage(),
          const RobotControlPage(showBackButton: false),
          const NotificationsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        child: LiquidGlassNavBar(
          currentIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          selectedColor: AppColors.primary,
          unselectedColor: AppColors.textSecondary,
          destinations: const [
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
          ],
        ),
      ),
    );
  }
}
