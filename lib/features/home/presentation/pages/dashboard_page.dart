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

/// Dashboard tab: premium IoT overview (no camera preview).
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    this.onNavigateToRobotControl,
  });

  /// When set (e.g. inside HomeShell), tapping "التحكم بالروبوت" switches to Robot tab instead of pushing a route.
  final VoidCallback? onNavigateToRobotControl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: LiquidGlassAppBar(
          title: const Text('الرئيسية'),
          actions: const [
            LogoutIconButton(),
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const _DashboardSkeleton();
            }
            if (state is DashboardFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.read<DashboardCubit>().load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (state is DashboardLoaded) {
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

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.data,
    this.onNavigateToRobotControl,
  });

  final DashboardData data;
  final VoidCallback? onNavigateToRobotControl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final username = data.username ?? 'مستخدم';
    return CustomScrollView(
      slivers: [
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 1,
              child: _RobotStatusOverviewCard(data: data),
            ),
          ),
        ),
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
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.crossAxisExtent;
              final crossAxisCount = w >= 900 ? 4 : w >= 600 ? 3 : 2;
              final aspect = w >= 900 ? 1.25 : w >= 600 ? 1.15 : 1.12;
              final tiles = _sensorCardsFrom(data);
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
                onStopRobot: () => _toast(context, 'سيتم ربط إيقاف الروبوت لاحقاً.'),
                onTogglePump: () => _toast(context, 'سيتم ربط تشغيل المضخة لاحقاً.'),
                onViewLog: () => context.push('/diagnosis'),
              ),
            ),
          ),
        ),
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          sliver: SliverToBoxAdapter(
            child: _DashboardEntrance(
              index: 13,
              child: _AlertsList(alerts: data.alerts),
            ),
          ),
        ),
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

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.surface,
    ),
  );
}

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting({
    required this.username,
    required this.online,
    required this.titleStyle,
  });

  final String username;
  final bool online;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        const SizedBox(width: 12),
        _OnlineDot(online: online),
      ],
    );
  }
}

class _OnlineDot extends StatefulWidget {
  const _OnlineDot({required this.online});

  final bool online;

  @override
  State<_OnlineDot> createState() => _OnlineDotState();
}

class _OnlineDotState extends State<_OnlineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.online ? AppColors.success : AppColors.error;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = 0.55 + _controller.value * 0.45;
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: base,
            shape: BoxShape.circle,
            boxShadow: [
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
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

class _RobotStatusOverviewCard extends StatelessWidget {
  const _RobotStatusOverviewCard({required this.data});

  final DashboardData data;

  @override
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
          Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: AppColors.primary),
              const SizedBox(width: 10),
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
              AppStatusTag(
                label: data.robotStatus.displayName,
                variant: statusVariant,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _KpiPill(
                label: 'الوضع',
                value: data.robotMode.displayName,
                icon: Icons.tune_rounded,
                color: AppColors.info,
              ),
              _KpiPill(
                label: 'البطارية',
                value: batteryText,
                icon: Icons.battery_full_rounded,
                color: AppColors.statusAdequate,
              ),
              _KpiPill(
                label: 'المضخة',
                value: (data.pumpOn ?? false) ? 'تشغيل' : 'إيقاف',
                icon: Icons.water_outlined,
                color: (data.pumpOn ?? false) ? AppColors.primary : AppColors.textMuted,
              ),
              _KpiPill(
                label: 'GPS',
                value: (data.gpsOnline ?? false) ? 'متاح' : 'غير متاح',
                icon: Icons.gps_fixed,
                color: (data.gpsOnline ?? false) ? AppColors.success : AppColors.warning,
              ),
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

class _KpiPill extends StatelessWidget {
  const _KpiPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
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
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
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

class _LatestAiDiagnosisCard extends StatelessWidget {
  const _LatestAiDiagnosisCard({
    required this.diagnosis,
    required this.onTapDetails,
  });

  final AiDiagnosis? diagnosis;
  final VoidCallback onTapDetails;

  @override
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
          Row(
            children: [
              Icon(Icons.auto_awesome, color: accent),
              const SizedBox(width: 10),
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'الثقة',
                  value: confidence,
                  color: accent,
                  icon: Icons.verified_outlined,
                ),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 10),
          Text(
            treatment,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
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
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
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
    _SensorSummaryCard(
      title: 'رطوبة التربة',
      value: d.soilMoisturePercent,
      unit: '%',
      icon: Icons.water_drop_outlined,
      color: AppColors.accentBlue,
    ),
    _SensorSummaryCard(
      title: 'مستوى الماء',
      value: d.waterLevelPercent,
      unit: '%',
      icon: Icons.opacity_outlined,
      color: AppColors.primaryLight,
    ),
  ];
}

class _SensorSummaryCard extends StatelessWidget {
  const _SensorSummaryCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  final String title;
  final double? value;
  final String unit;
  final IconData icon;
  final Color color;

  @override
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

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({
    required this.onOpenControl,
    required this.onStartScan,
    required this.onStopRobot,
    required this.onTogglePump,
    required this.onViewLog,
  });

  final VoidCallback onOpenControl;
  final VoidCallback onStartScan;
  final VoidCallback onStopRobot;
  final VoidCallback onTogglePump;
  final VoidCallback onViewLog;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _QuickActionButton(
          label: 'فتح لوحة التحكم',
          icon: Icons.smart_toy_outlined,
          onTap: onOpenControl,
          primary: true,
        ),
        _QuickActionButton(
          label: 'بدء الفحص',
          icon: Icons.center_focus_strong_outlined,
          onTap: onStartScan,
        ),
        _QuickActionButton(
          label: 'إيقاف الروبوت',
          icon: Icons.stop_circle_outlined,
          onTap: onStopRobot,
          danger: true,
        ),
        _QuickActionButton(
          label: 'تشغيل المضخة',
          icon: Icons.water_outlined,
          onTap: onTogglePump,
        ),
        _QuickActionButton(
          label: 'عرض السجل',
          icon: Icons.history_rounded,
          onTap: onViewLog,
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.primary;
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
                  Icon(icon, color: primary ? AppColors.textOnPrimary : color, size: 18),
                  const SizedBox(width: 10),
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

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});

  final List<DashboardAlert> alerts;

  @override
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: LiquidGlassPanel(
            borderRadius: LiquidGlassTokens.radiusSm,
            blurSigma: LiquidGlassTokens.blurSoft,
            accentBorder: color,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                const SizedBox(width: 10),
                Text(
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

class _DailyStatsRow extends StatelessWidget {
  const _DailyStatsRow({required this.stats});

  final DailyStats? stats;

  @override
  Widget build(BuildContext context) {
    final s = stats;
    final last = s?.lastScanTime == null ? '—' : _formatRelativeTime(s!.lastScanTime!);
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatChip(
          label: 'عدد النباتات المفحوصة اليوم',
          value: s?.plantsScannedToday.toString() ?? '—',
          icon: Icons.grass_outlined,
          color: AppColors.primary,
        ),
        _StatChip(
          label: 'عدد الأمراض المكتشفة',
          value: s?.diseasesDetected.toString() ?? '—',
          icon: Icons.bug_report_outlined,
          color: AppColors.warning,
        ),
        _StatChip(
          label: 'عدد النباتات السليمة',
          value: s?.healthyPlants.toString() ?? '—',
          icon: Icons.verified_outlined,
          color: AppColors.success,
        ),
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

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
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
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
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

String _formatRelativeTime(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  return 'قبل ${diff.inDays} ي';
}

class _DashboardEntrance extends StatelessWidget {
  const _DashboardEntrance({required this.child, required this.index});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + (index * 40).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
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

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
      children: const [
        _SkeletonBox(height: 56),
        SizedBox(height: 14),
        _SkeletonBox(height: 120),
        SizedBox(height: 14),
        _SkeletonBox(height: 150),
        SizedBox(height: 14),
        _SkeletonGrid(),
        SizedBox(height: 18),
        _SkeletonBox(height: 86),
        SizedBox(height: 14),
        _SkeletonBox(height: 140),
        SizedBox(height: 14),
        _SkeletonBox(height: 110),
      ],
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final crossAxisCount = w >= 900 ? 4 : w >= 600 ? 3 : 2;
        final itemCount = 6;
        final rows = (itemCount / crossAxisCount).ceil();
        return Column(
          children: List.generate(rows, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: row == rows - 1 ? 0 : 12),
              child: Row(
                children: List.generate(crossAxisCount, (col) {
                  final idx = row * crossAxisCount + col;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: col == 0 ? 0 : 12),
                      child: idx < itemCount
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

class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({required this.height});

  final double height;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
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
