// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: dashboard_page.dart
// المسار: features/home/presentation/pages/dashboard_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الرئيسية ولوحة التحكم. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • DashboardPage
//   • _DashboardContent
//   • _HeroGreeting
//   • _OnlineDot
//   • _OnlineDotState
//   • _SectionHeader
//   • _statusLabelFor()
//   • _formatRelativeTime()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../../core/widgets/app_data_card.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_status_tag.dart';
import '../../../auth/presentation/widgets/logout_icon_button.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/robot_status.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
/// شاشة لوحة التحكم.
class DashboardPage extends StatelessWidget {
  /// دالة لوحة التحكم صفحة.
  const DashboardPage({
    super.key,
    this.onNavigateToRobotControl,
  });

  /// When set (e.g. inside HomeShell), tapping "التحكم بالروبوت" switches to Robot tab instead of pushing a route.
  final VoidCallback? onNavigateToRobotControl;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: LiquidGlassAppBar(
          title: const Text('الرئيسية'),
          actions: const [
          /// دالة تسجيل خروج أيقونة زر.
            LogoutIconButton(),
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              /// دالة داخلية: لوحة التحكم skeleton.
              return const _DashboardSkeleton();
            }
            if (state is DashboardFailure) {
              /// دالة center.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  /// دالة نص.
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 16),
                  /// دالة نص زر.
                    TextButton(
                      onPressed: () => context.read<DashboardCubit>().load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (state is DashboardLoaded) {
              /// دالة داخلية: لوحة التحكم content.
              return _DashboardContent(
                data: state.data,
                onNavigateToRobotControl: onNavigateToRobotControl,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// كلاس لوحة التحكم content.
class _DashboardContent extends StatelessWidget {
  /// دالة داخلية: لوحة التحكم content.
  const _DashboardContent({
    required this.data,
    this.onNavigateToRobotControl,
  });

  /// حقل: بيانات.
  final DashboardData data;
  /// حقل: on navigate to الروبوت التحكم.
  final VoidCallback? onNavigateToRobotControl;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final username = data.username ?? 'مستخدم';
    return CustomScrollView(
      slivers: [
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 0,
              child: _HeroGreeting(
                titleStyle: theme.headlineMedium,
                username: username,
                online: data.robotStatus == RobotStatus.online,
              ),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 1,
              child: _RobotStatusOverviewCard(data: data),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 2,
              child: _LatestAiDiagnosisCard(
                diagnosis: data.latestAiDiagnosis,
                onTapDetails: () => context.push('/diagnosis'),
              ),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          sliver: SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'ملخص المستشعرات',
              subtitle: 'نظرة سريعة على أهم القراءات',
              actionLabel: 'لوحة المستشعرات',
              onAction: () => context.go('/?tab=sensors'),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.crossAxisExtent;
              final crossAxisCount = w >= 900 ? 4 : w >= 600 ? 3 : 2;
              final aspect = w >= 900 ? 1.25 : w >= 600 ? 1.15 : 1.12;
              final tiles = _sensorCardsFrom(data);
              /// دالة sliver grid.
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: aspect,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _DashboardEntrance(
                    index: 3 + index,
                    child: tiles[index],
                  ),
                  childCount: tiles.length,
                ),
              );
            },
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
          sliver: SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'إجراءات سريعة',
              subtitle: 'تنقّل وتشغيل أوامر شائعة',
              actionLabel: null,
              onAction: null,
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 12,
              child: _QuickActionsRow(
                onOpenControl: () {
                  if (onNavigateToRobotControl != null) {
                    onNavigateToRobotControl!();
                  } else {
                    context.push('/robot-control');
                  }
                },
                onStartScan: () => context.push('/robot-control'),
                onViewLog: () => context.push('/diagnosis'),
              ),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          sliver: SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'التنبيهات',
              subtitle: 'آخر الأحداث ذات الأولوية',
              actionLabel: 'عرض الكل',
              onAction: () => context.go('/?tab=alerts'),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 13,
              child: _AlertsList(alerts: data.alerts),
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          sliver: SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'إحصائيات اليوم',
              subtitle: 'ملخص سريع للنتائج',
              actionLabel: null,
              onAction: null,
            ),
          ),
        ),
      /// دالة sliver padding.
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 14,
              child: _DailyStatsRow(stats: data.dailyStats),
            ),
          ),
        ),
      ],
    );
  }
}

/// كلاس hero greeting.
class _HeroGreeting extends StatelessWidget {
  /// دالة داخلية: hero greeting.
  const _HeroGreeting({
    required this.username,
    required this.online,
    required this.titleStyle,
  });

  /// حقل: username.
  final String username;
  /// حقل: متصل.
  final bool online;
  /// حقل: title style.
  final TextStyle? titleStyle;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Row(
      children: [
      /// دالة expanded.
        Expanded(
          child: AppHeader(
            title: '، $username',
            titleAccent: 'مرحباً',
            titleStyle: titleStyle,
            subtitle: 'لوحة تحكم الروبوت الزراعي الذكي',
            subtitleStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        /// دالة sized box.
        const SizedBox(width: 12),
      /// دالة داخلية: متصل نقطة.
        _OnlineDot(online: online),
      ],
    );
  }
}

/// كلاس متصل نقطة.
class _OnlineDot extends StatefulWidget {
  /// دالة داخلية: متصل نقطة.
  const _OnlineDot({required this.online});

  /// حقل: متصل.
  final bool online;

  @override
  /// ينشئ الحالة.
  State<_OnlineDot> createState() => _OnlineDotState();
}

/// حالة واجهة متصل نقطة.
class _OnlineDotState extends State<_OnlineDot>
    with SingleTickerProviderStateMixin {
  /// حقل: controller.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  /// ينظف الموارد.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final base = widget.online ? AppColors.success : AppColors.error;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = 0.55 + _controller.value * 0.45;
        /// دالة container.
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: base,
            shape: BoxShape.circle,
            boxShadow: [
            /// دالة box shadow.
              BoxShadow(
                color: base.withValues(alpha: 0.28 * t),
                blurRadius: 16 * t,
                spreadRadius: 1.5 * t,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// كلاس section رأس.
class _SectionHeader extends StatelessWidget {
  /// دالة داخلية: section رأس.
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  /// حقل: title.
  final String title;
  /// حقل: subtitle.
  final String subtitle;
  /// حقل: إجراء label.
  final String? actionLabel;
  /// حقل: on إجراء.
  final VoidCallback? onAction;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Row(
      children: [
      /// دالة expanded.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /// دالة نص.
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              /// دالة sized box.
              const SizedBox(height: 4),
            /// دالة نص.
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
        /// دالة نص زر.
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
            child: Text(
              actionLabel!,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/// مكوّن واجهة: الروبوت الحالة overview بطاقة.
class _RobotStatusOverviewCard extends StatelessWidget {
  /// دالة داخلية: الروبوت الحالة overview بطاقة.
  const _RobotStatusOverviewCard({required this.data});

  /// حقل: بيانات.
  final DashboardData data;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final statusVariant = data.robotStatus == RobotStatus.online
        ? AppStatusTagVariant.success
        : data.robotStatus == RobotStatus.offline
            ? AppStatusTagVariant.error
            : AppStatusTagVariant.info;

    final batteryText = data.batteryPercent != null
        ? '${data.batteryPercent!.toStringAsFixed(0)}%'
        : '—';
    final tankText = data.waterTankLevelPercent != null
        ? '${data.waterTankLevelPercent!.toStringAsFixed(0)}%'
        : '—';

    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        /// دالة صف.
          Row(
            children: [
              /// دالة أيقونة.
              const Icon(Icons.smart_toy_outlined, color: AppColors.primary),
              /// دالة sized box.
              const SizedBox(width: 10),
              /// دالة expanded.
              const Expanded(
                child: Text(
                  'نظرة عامة على الروبوت',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            /// دالة التطبيق الحالة وسم.
              AppStatusTag(
                label: data.robotStatus.displayName,
                variant: statusVariant,
              ),
            ],
          ),
          /// دالة sized box.
          const SizedBox(height: 14),
        /// دالة wrap.
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
            /// دالة داخلية: kpi pill.
              _KpiPill(
                label: 'الوضع',
                value: data.robotMode.displayName,
                icon: Icons.tune_rounded,
                color: AppColors.info,
              ),
            /// دالة داخلية: kpi pill.
              _KpiPill(
                label: 'البطارية',
                value: batteryText,
                icon: Icons.battery_full_rounded,
                color: AppColors.statusAdequate,
              ),
            /// دالة داخلية: kpi pill.
              _KpiPill(
                label: 'المضخة',
                value: (data.pumpOn ?? false) ? 'تشغيل' : 'إيقاف',
                icon: Icons.water_outlined,
                color: (data.pumpOn ?? false) ? AppColors.primary : AppColors.textMuted,
              ),
            /// دالة داخلية: kpi pill.
              _KpiPill(
                label: 'GPS',
                value: (data.gpsOnline ?? false) ? 'متاح' : 'غير متاح',
                icon: Icons.gps_fixed,
                color: (data.gpsOnline ?? false) ? AppColors.success : AppColors.warning,
              ),
            /// دالة داخلية: kpi pill.
              _KpiPill(
                label: 'الخزان',
                value: tankText,
                icon: Icons.local_drink_outlined,
                color: AppColors.primaryLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// كلاس kpi pill.
class _KpiPill extends StatelessWidget {
  /// دالة داخلية: kpi pill.
  const _KpiPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  /// حقل: label.
  final String label;
  /// حقل: value.
  final String value;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: color.
  final Color color;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        /// دالة أيقونة.
          Icon(icon, color: color, size: 16),
          /// دالة sized box.
          const SizedBox(width: 8),
        /// دالة column.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            /// دالة نص.
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              /// دالة sized box.
              const SizedBox(height: 2),
            /// دالة نص.
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// مكوّن واجهة: latest الذكاء الاصطناعي التشخيص بطاقة.
class _LatestAiDiagnosisCard extends StatelessWidget {
  /// دالة داخلية: latest الذكاء الاصطناعي التشخيص بطاقة.
  const _LatestAiDiagnosisCard({
    required this.diagnosis,
    required this.onTapDetails,
  });

  /// حقل: التشخيص.
  final AiDiagnosis? diagnosis;
  /// حقل: on tap details.
  final VoidCallback onTapDetails;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final d = diagnosis;
    final isHealthy = d?.isHealthy ?? false;
    final accent = d == null
        ? AppColors.textMuted
        : isHealthy
            ? AppColors.success
            : AppColors.warning;
    final title = d == null ? 'لا توجد نتائج بعد' : (isHealthy ? 'سليم' : d.resultName);
    final confidence = d == null ? '—' : '${(d.confidence * 100).toStringAsFixed(0)}%';
    final treatment = d == null ? 'ابدأ فحصاً جديداً للحصول على نتيجة.' : d.suggestedTreatment;
    final scanTime = d == null ? '—' : _formatRelativeTime(d.lastScanAt);

    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      accentBorder: accent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        /// دالة صف.
          Row(
            children: [
            /// دالة أيقونة.
              Icon(Icons.auto_awesome, color: accent),
              /// دالة sized box.
              const SizedBox(width: 10),
              /// دالة expanded.
              const Expanded(
                child: Text(
                  'آخر تشخيص بالذكاء الاصطناعي',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            /// دالة container.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withValues(alpha: 0.35)),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          /// دالة sized box.
          const SizedBox(height: 12),
        /// دالة صف.
          Row(
            children: [
            /// دالة expanded.
              Expanded(
                child: _MiniStat(
                  label: 'الثقة',
                  value: confidence,
                  color: accent,
                  icon: Icons.verified_outlined,
                ),
              ),
              /// دالة sized box.
              const SizedBox(width: 12),
            /// دالة expanded.
              Expanded(
                child: _MiniStat(
                  label: 'آخر فحص',
                  value: scanTime,
                  color: AppColors.textSecondary,
                  icon: Icons.update,
                ),
              ),
            ],
          ),
          /// دالة sized box.
          const SizedBox(height: 10),
        /// دالة نص.
          Text(
            treatment,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 12),
        /// دالة align.
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onTapDetails,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: const Text(
                'عرض التفاصيل',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// كلاس mini stat.
class _MiniStat extends StatelessWidget {
  /// دالة داخلية: mini stat.
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  /// حقل: label.
  final String label;
  /// حقل: value.
  final String value;
  /// حقل: color.
  final Color color;
  /// حقل: أيقونة.
  final IconData icon;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
        /// دالة أيقونة.
          Icon(icon, color: color, size: 16),
          /// دالة sized box.
          const SizedBox(width: 8),
        /// دالة expanded.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              /// دالة نص.
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                /// دالة sized box.
                const SizedBox(height: 2),
              /// دالة نص.
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _sensorCardsFrom(DashboardData d) {
  return [
  /// دالة داخلية: المستشعر summary بطاقة.
    _SensorSummaryCard(
      title: 'رطوبة التربة',
      value: d.soilMoisturePercent,
      unit: '%',
      icon: Icons.water_drop_outlined,
      color: AppColors.accentBlue,
    ),
  /// دالة داخلية: المستشعر summary بطاقة.
    _SensorSummaryCard(
      title: 'مستوى الماء',
      value: d.waterLevelPercent,
      unit: '%',
      icon: Icons.opacity_outlined,
      color: AppColors.primaryLight,
    ),
  ];
}

/// مكوّن واجهة: المستشعر summary بطاقة.
class _SensorSummaryCard extends StatelessWidget {
  /// دالة داخلية: المستشعر summary بطاقة.
  const _SensorSummaryCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  /// حقل: title.
  final String title;
  /// حقل: value.
  final double? value;
  /// حقل: unit.
  final String unit;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: color.
  final Color color;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final valueText = value == null
        ? '—'
        : unit == '%'
            ? '${value!.toStringAsFixed(1)}$unit'
            : unit == '°C'
                ? '${value!.toStringAsFixed(1)}$unit'
                : value!.toStringAsFixed(1);

    final status = value == null
        ? 'غير متاح'
        : _statusLabelFor(title, value!);
    final trend = value == null ? null : _fakeTrendFor(title, value!);
    final trendPositive = trend == null ? true : !trend.startsWith('-');

    return AppDataCard(
      label: title,
      value: valueText,
      icon: icon,
      iconColor: color,
      statusLabel: status,
      trend: trend,
      trendPositive: trendPositive,
    );
  }
}

/// دالة داخلية: الحالة label for.
String _statusLabelFor(String sensor, double v) {
  switch (sensor) {
    case 'رطوبة التربة':
      return v >= 40 ? 'جيد' : v >= 25 ? 'متوسط' : 'منخفض';
    case 'pH':
      return (v >= 6.0 && v <= 7.5) ? 'طبيعي' : 'تحقق';
    case 'EC':
      return v <= 2.0 ? 'طبيعي' : 'مرتفع';
    case 'مستوى الماء':
      return v >= 40 ? 'ممتلئ' : v >= 20 ? 'منخفض' : 'حرج';
    case 'الحرارة':
      return (v >= 10 && v <= 34) ? 'مناسب' : 'تحذير';
    case 'الرطوبة':
      return (v >= 35 && v <= 75) ? 'مناسب' : 'تحذير';
    default:
      return '—';
  }
}

String? _fakeTrendFor(String sensor, double v) {
  // Placeholder trend until RTDB history is available.
  if (sensor == 'pH' || sensor == 'EC') return null;
  final mod = (v * 10).round() % 3;
  if (mod == 0) return '+2%';
  if (mod == 1) return '-1%';
  return null;
}

/// كلاس quick actions صف.
class _QuickActionsRow extends StatelessWidget {
  /// دالة داخلية: quick actions صف.
  const _QuickActionsRow({
    required this.onOpenControl,
    required this.onStartScan,
    required this.onViewLog,
  });

  /// حقل: on فتح التحكم.
  final VoidCallback onOpenControl;
  /// حقل: on start scan.
  final VoidCallback onStartScan;
  /// حقل: on عرض log.
  final VoidCallback onViewLog;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
      /// دالة داخلية: quick إجراء زر.
        _QuickActionButton(
          label: 'فتح لوحة التحكم',
          icon: Icons.smart_toy_outlined,
          onTap: onOpenControl,
          primary: true,
        ),
      /// دالة داخلية: quick إجراء زر.
        _QuickActionButton(
          label: 'بدء الفحص',
          icon: Icons.center_focus_strong_outlined,
          onTap: onStartScan,
        ),
      /// دالة داخلية: quick إجراء زر.
        _QuickActionButton(
          label: 'عرض السجل',
          icon: Icons.history_rounded,
          onTap: onViewLog,
        ),
      ],
    );
  }
}

/// مكوّن واجهة: quick إجراء زر.
class _QuickActionButton extends StatelessWidget {
  /// دالة داخلية: quick إجراء زر.
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  /// حقل: label.
  final String label;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: on tap.
  final VoidCallback onTap;
  /// حقل: رئيسي.
  final bool primary;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final color = AppColors.primary;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 160),
      child: Material(
        color: Colors.transparent,
        child: LiquidGlassPanel(
          borderRadius: 14,
          blurSigma: LiquidGlassTokens.blurSoft,
          accentBorder: primary ? AppColors.primaryLight : color.withValues(alpha: 0.55),
          gradientColors: primary
              ? [
                  AppColors.primary.withValues(alpha: 0.46),
                  AppColors.primaryDark.withValues(alpha: 0.36),
                ]
              : null,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                /// دالة أيقونة.
                  Icon(icon, color: primary ? AppColors.textOnPrimary : color, size: 18),
                  /// دالة sized box.
                  const SizedBox(width: 10),
                /// دالة expanded.
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primary ? AppColors.textOnPrimary : AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// كلاس تنبيهات list.
class _AlertsList extends StatelessWidget {
  /// دالة داخلية: تنبيهات list.
  const _AlertsList({required this.alerts});

  /// حقل: تنبيهات.
  final List<DashboardAlert> alerts;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'لا توجد تنبيهات حالياً.',
          style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
        ),
      );
    }
    return Column(
      children: alerts.take(5).map((a) {
        final color = switch (a.priority) {
          AlertPriority.high => AppColors.error,
          AlertPriority.medium => AppColors.warning,
          AlertPriority.low => AppColors.info,
        };
        /// دالة padding.
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LiquidGlassPanel(
            borderRadius: LiquidGlassTokens.radiusSm,
            blurSigma: LiquidGlassTokens.blurSoft,
            accentBorder: color,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
              /// دالة container.
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Icon(
                    a.priority == AlertPriority.high
                        ? Icons.priority_high_rounded
                        : a.priority == AlertPriority.medium
                            ? Icons.warning_amber_rounded
                            : Icons.notifications_outlined,
                    color: color,
                    size: 20,
                  ),
                ),
                /// دالة sized box.
                const SizedBox(width: 12),
              /// دالة expanded.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    /// دالة نص.
                      Text(
                        a.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      /// دالة sized box.
                      const SizedBox(height: 4),
                    /// دالة نص.
                      Text(
                        a.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                /// دالة sized box.
                const SizedBox(width: 10),
              /// دالة نص.
                Text(
                /// دالة داخلية: format relative time.
                  _formatRelativeTime(a.time),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// كلاس daily stats صف.
class _DailyStatsRow extends StatelessWidget {
  /// دالة داخلية: daily stats صف.
  const _DailyStatsRow({required this.stats});

  /// حقل: stats.
  final DailyStats? stats;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final s = stats;
    final last = s?.lastScanTime == null ? '—' : _formatRelativeTime(s!.lastScanTime!);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
      /// دالة داخلية: stat شريحة.
        _StatChip(
          label: 'عدد النباتات المفحوصة اليوم',
          value: s?.plantsScannedToday.toString() ?? '—',
          icon: Icons.grass_outlined,
          color: AppColors.primary,
        ),
      /// دالة داخلية: stat شريحة.
        _StatChip(
          label: 'عدد الأمراض المكتشفة',
          value: s?.diseasesDetected.toString() ?? '—',
          icon: Icons.bug_report_outlined,
          color: AppColors.warning,
        ),
      /// دالة داخلية: stat شريحة.
        _StatChip(
          label: 'عدد النباتات السليمة',
          value: s?.healthyPlants.toString() ?? '—',
          icon: Icons.verified_outlined,
          color: AppColors.success,
        ),
      /// دالة داخلية: stat شريحة.
        _StatChip(
          label: 'آخر وقت فحص',
          value: last,
          icon: Icons.update,
          color: AppColors.info,
        ),
      ],
    );
  }
}

/// كلاس stat شريحة.
class _StatChip extends StatelessWidget {
  /// دالة داخلية: stat شريحة.
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  /// حقل: label.
  final String label;
  /// حقل: value.
  final String value;
  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: color.
  final Color color;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 240),
      child: LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        accentBorder: color,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
          /// دالة أيقونة.
            Icon(icon, color: color, size: 18),
            /// دالة sized box.
            const SizedBox(width: 10),
          /// دالة expanded.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                /// دالة نص.
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  /// دالة sized box.
                  const SizedBox(height: 3),
                /// دالة نص.
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// دالة داخلية: format relative time.
String _formatRelativeTime(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  return 'قبل ${diff.inDays} ي';
}

/// كلاس لوحة التحكم entrance.
class _DashboardEntrance extends StatelessWidget {
  /// دالة داخلية: لوحة التحكم entrance.
  const _DashboardEntrance({required this.child, required this.index});

  /// حقل: child.
  final Widget child;
  /// حقل: index.
  final int index;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + (index * 40).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        /// دالة opacity.
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 12),
            child: child,
          ),
        );
      },
    );
  }
}

/// كلاس لوحة التحكم skeleton.
class _DashboardSkeleton extends StatelessWidget {
  /// دالة داخلية: لوحة التحكم skeleton.
  const _DashboardSkeleton();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: const [
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 56),
      /// دالة sized box.
        SizedBox(height: 14),
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 120),
      /// دالة sized box.
        SizedBox(height: 14),
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 150),
      /// دالة sized box.
        SizedBox(height: 14),
      /// دالة داخلية: skeleton grid.
        _SkeletonGrid(),
      /// دالة sized box.
        SizedBox(height: 18),
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 86),
      /// دالة sized box.
        SizedBox(height: 14),
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 140),
      /// دالة sized box.
        SizedBox(height: 14),
      /// دالة داخلية: skeleton box.
        _SkeletonBox(height: 110),
      ],
    );
  }
}

/// كلاس skeleton grid.
class _SkeletonGrid extends StatelessWidget {
  /// دالة داخلية: skeleton grid.
  const _SkeletonGrid();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = w >= 900 ? 4 : w >= 600 ? 3 : 2;
        final itemCount = 6;
        final rows = (itemCount / crossAxisCount).ceil();
        /// دالة column.
        return Column(
          children: List.generate(rows, (row) {
            /// دالة padding.
            return Padding(
              padding: EdgeInsets.only(bottom: row == rows - 1 ? 0 : 12),
              child: Row(
                children: List.generate(crossAxisCount, (col) {
                  final idx = row * crossAxisCount + col;
                  /// دالة expanded.
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: col == 0 ? 0 : 12),
                      child: idx < itemCount
                          /// دالة داخلية: skeleton box.
                          ? const _SkeletonBox(height: 92)
                          : const SizedBox.shrink(),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      },
    );
  }
}

/// كلاس skeleton box.
class _SkeletonBox extends StatefulWidget {
  /// دالة داخلية: skeleton box.
  const _SkeletonBox({required this.height});

  /// حقل: height.
  final double height;

  @override
  /// ينشئ الحالة.
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

/// حالة واجهة skeleton box.
class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  /// حقل: controller.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  /// ينظف الموارد.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        /// دالة زجاجي زجاج لوحة.
        return LiquidGlassPanel(
          borderRadius: LiquidGlassTokens.radiusSm,
          blurSigma: LiquidGlassTokens.blurSoft,
          padding: const EdgeInsets.all(0),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(LiquidGlassTokens.radiusSm),
              gradient: LinearGradient(
                begin: Alignment(-1 + t * 2, -0.2),
                end: Alignment(1 + t * 2, 0.2),
                colors: [
                  AppColors.surface.withValues(alpha: 0.35),
                  AppColors.surfaceVariant.withValues(alpha: 0.25),
                  AppColors.surface.withValues(alpha: 0.35),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
