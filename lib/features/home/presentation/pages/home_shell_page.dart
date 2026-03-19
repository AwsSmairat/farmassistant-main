import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../robot/presentation/pages/robot_control_page.dart';
import 'alerts_page.dart';
import 'dashboard_page.dart';
import 'sensors_page.dart';

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

  static const int _dashboardIndex = 0;
  static const int _robotIndex = 1;
  static const int _sensorsIndex = 2;
  static const int _alertsIndex = 3;
  static const int _profileIndex = 4;

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
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardPage(
            onNavigateToRobotControl: () =>
                setState(() => _currentIndex = _robotIndex),
          ),
          const RobotControlPage(showBackButton: false),
          const SensorsPage(),
          const AlertsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.navBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: 'الروبوت',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors_outlined),
            activeIcon: Icon(Icons.sensors),
            label: 'المستشعرات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'التنبيهات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'الملف',
          ),
        ],
      ),
    );
  }
}
