// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: home_shell_page.dart
// المسار: features/home/presentation/pages/home_shell_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • HomeShellPage
//   • _HomeShellPageState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../ai_plant_diagnosis/presentation/widgets/ai_diagnosis_shell_layers.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../robot/presentation/cubit/robot_control_cubit.dart';
import '../../../robot/presentation/pages/robot_control_page.dart';
import '../../../sensors/presentation/pages/sensors_page.dart';
import 'dashboard_page.dart';
/// شاشة الرئيسية الهيكل الرئيسي.
class HomeShellPage extends StatefulWidget {
  /// دالة الرئيسية الهيكل الرئيسي صفحة.
  const HomeShellPage({super.key, this.initialIndex = 0});

  /// حقل: initial index.
  final int initialIndex;

  @override
  /// ينشئ الحالة.
  State<HomeShellPage> createState() => _HomeShellPageState();
}

/// حالة واجهة الرئيسية الهيكل الرئيسي صفحة.
class _HomeShellPageState extends State<HomeShellPage> {
  /// حقل: current index.
  late int _currentIndex;

  /// حقل: الروبوت tab index.
  static const int _robotTabIndex = 2;

  @override
  /// يهيّئ الويدجت.
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  @override
  /// يستجيب لتغيّر خصائص الويدجت.
  void didUpdateWidget(HomeShellPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex.clamp(0, 4);
    }
  }

  /// دالة داخلية: pages.
  List<Widget> _pages({required void Function() onNavigateToRobot}) {
    return [
    /// دالة لوحة التحكم صفحة.
      DashboardPage(onNavigateToRobotControl: onNavigateToRobot),
      /// دالة المستشعرات صفحة.
      const SensorsPage(),
      // تبويب الروبوت: Cubit مستقل يستمع لـ robot_status ويرسل الأوامر.
    /// دالة bloc provider.
      BlocProvider(
        create: (_) => getIt<RobotControlCubit>(),
        child: const RobotControlPage(showBackButton: false),
      ),
      /// دالة التنبيهات صفحة.
      const NotificationsPage(),
      /// دالة الملف الشخصي صفحة.
      const ProfilePage(),
    ];
  }

  static const _destinations = [
  /// دالة زجاجي زجاج nav destination.
    LiquidGlassNavDestination(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'الرئيسية',
    ),
  /// دالة زجاجي زجاج nav destination.
    LiquidGlassNavDestination(
      icon: Icons.sensors_outlined,
      activeIcon: Icons.sensors,
      label: 'المستشعرات',
    ),
  /// دالة زجاجي زجاج nav destination.
    LiquidGlassNavDestination(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy,
      label: 'الروبوت',
    ),
  /// دالة زجاجي زجاج nav destination.
    LiquidGlassNavDestination(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications,
      label: 'التنبيهات',
    ),
  /// دالة زجاجي زجاج nav destination.
    LiquidGlassNavDestination(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'الملف',
    ),
  ];

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = AppBreakpoints.useNavigationRail(constraints.maxWidth);
        final pages = _pages(
          onNavigateToRobot: () =>
            /// يعيّن الحالة.
              setState(() => _currentIndex = _robotTabIndex),
        );

        if (!wide) {
          /// دالة scaffold.
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AiDiagnosisPhoneBodyLayer(
              showAiFab: _currentIndex == 0,
              child: IndexedStack(index: _currentIndex, children: pages),
            ),
            bottomNavigationBar: LiquidGlassBottomBar(
              child: LiquidGlassNavBar(
                currentIndex: _currentIndex,
                onDestinationSelected: (index) =>
                  /// يعيّن الحالة.
                    setState(() => _currentIndex = index),
                selectedColor: AppColors.primary,
                unselectedColor: AppColors.textSecondary,
                destinations: _destinations,
              ),
            ),
          );
        }

        final expandedRail = constraints.maxWidth >= AppBreakpoints.expanded;

        /// دالة scaffold.
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
            /// دالة صف.
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                /// دالة تنقل rail.
                  NavigationRail(
                    extended: expandedRail,
                    backgroundColor: AppColors.navBackground.withValues(
                      alpha: 0.92,
                    ),
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (i) =>
                      /// يعيّن الحالة.
                        setState(() => _currentIndex = i),
                    // Material constraint: [extended] requires [labelType] == none
                    // (labels sit beside icons when extended).
                    labelType: expandedRail
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.selected,
                    indicatorColor: AppColors.primary.withValues(alpha: 0.22),
                    selectedIconTheme: const IconThemeData(
                      color: AppColors.primary,
                    ),
                    unselectedIconTheme: const IconThemeData(
                      color: AppColors.textSecondary,
                    ),
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
                    /// دالة for.
                      for (var i = 0; i < _destinations.length; i++)
                      /// دالة تنقل rail destination.
                        NavigationRailDestination(
                          icon: Icon(_destinations[i].icon),
                          selectedIcon: Icon(_destinations[i].activeIcon),
                          label: Text(_destinations[i].label),
                        ),
                    ],
                  ),
                  /// دالة vertical divider.
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                /// دالة expanded.
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, inner) {
                        final maxContent =
                            inner.maxWidth >= AppBreakpoints.expanded
                            ? AppBreakpoints.expanded
                            : inner.maxWidth;
                        /// دالة الذكاء الاصطناعي التشخيص wide content layer.
                        return AiDiagnosisWideContentLayer(
                          showAiFab: _currentIndex == 0,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxContent),
                              child: IndexedStack(
                                index: _currentIndex,
                                children: pages,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
