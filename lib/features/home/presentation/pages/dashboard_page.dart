import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../../core/widgets/app_action_card.dart';
import '../../../../core/widgets/app_data_card.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/app_status_tag.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/robot_status.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

/// Dashboard tab: username, robot status, last sensor readings, quick link to Robot Control.
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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await getIt<SignOut>().call();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
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
    final robotStatus = data.robotStatus;
    final statusVariant = robotStatus == RobotStatus.online
        ? AppStatusTagVariant.success
        : robotStatus == RobotStatus.offline
            ? AppStatusTagVariant.error
            : AppStatusTagVariant.info;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(
            title: '، $username',
            titleAccent: 'مرحباً',
            titleStyle: theme.headlineMedium,
            subtitle: null,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة الروبوت',
                style: theme.labelLarge?.copyWith(color: AppColors.textSecondary),
              ),
              AppStatusTag(
                label: robotStatus.displayName,
                variant: statusVariant,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppDataCard(
            label: 'آخر قراءة رطوبة',
            value: data.lastMoisture != null
                ? '${data.lastMoisture!.toStringAsFixed(1)}%'
                : '—',
            icon: Icons.water_drop,
            iconColor: AppColors.accentBlue,
          ),
          const SizedBox(height: 12),
          AppDataCard(
            label: 'آخر قراءة pH',
            value: data.lastPh?.toStringAsFixed(1) ?? '—',
            icon: Icons.science,
            iconColor: AppColors.accentPurple,
          ),
          const SizedBox(height: 12),
          AppDataCard(
            label: 'آخر قراءة EC',
            value: data.lastEc?.toStringAsFixed(1) ?? '—',
            icon: Icons.bolt,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 32),
          AppActionCard(
            title: 'التحكم بالروبوت',
            description: 'فتح لوحة التحكم',
            icon: Icons.smart_toy,
            primary: true,
            onTap: () {
              if (onNavigateToRobotControl != null) {
                onNavigateToRobotControl!();
              } else {
                context.push('/robot-control');
              }
            },
          ),
        ],
      ),
    );
  }
}
