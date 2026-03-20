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

  static const int _dashboardIndex = 0;
  static const int _sensorsIndex = 1;
  static const int _robotIndex = 2;
  static const int _alertsIndex = 3;
  static const int _profileIndex = 4;

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: isSelected ? const Offset(0, -0.16) : Offset.zero,
        child: Icon(icon),
      ),
      activeIcon: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        offset: isSelected ? const Offset(0, -0.16) : Offset.zero,
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }

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
                setState(() => _currentIndex = _robotIndex),
          ),
          const SensorsPage(),
          const RobotControlPage(showBackButton: false),
          const NotificationsPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          items: [
          _buildNavItem(
            index: _dashboardIndex,
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'الرئيسية',
          ),
          _buildNavItem(
            index: _sensorsIndex,
            icon: Icons.sensors_outlined,
            activeIcon: Icons.sensors,
            label: 'المستشعرات',
          ),
          _buildNavItem(
            index: _robotIndex,
            icon: Icons.smart_toy_outlined,
            activeIcon: Icons.smart_toy,
            label: 'الروبوت',
          ),
          _buildNavItem(
            index: _alertsIndex,
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: 'التنبيهات',
          ),
          _buildNavItem(
            index: _profileIndex,
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
