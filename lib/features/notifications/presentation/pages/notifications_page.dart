import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../domain/entities/farm_notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..start(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationsCubit>().clearAll(),
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading || state is NotificationsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is NotificationsFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }
            if (state is! NotificationsReady) {
              return const SizedBox.shrink();
            }
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد إشعارات حالياً',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return _NotificationItem(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.item});

  final FarmNotification item;

  @override
  Widget build(BuildContext context) {
    final visual = _visuals(item.severity);
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<NotificationsCubit>().deleteById(item.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      child: InkWell(
        onTap: () async {
          await context.read<NotificationsCubit>().markAsRead(item.id);
          if (!context.mounted) return;
          context.go('/?tab=${_tabForCategory(item.category)}');
        },
        borderRadius: BorderRadius.circular(14),
        child: LiquidGlassPanel(
          borderRadius: 14,
          blurSigma: LiquidGlassTokens.blurSoft,
          accentBorder: visual.color,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: visual.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(visual.icon, color: visual.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          _categoryLabel(item.category),
                          style: TextStyle(
                            color: visual.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _timeLabel(item.timestamp),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _tabForCategory(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.sensorAlert:
      return 'sensors';
    case NotificationCategory.robotStatus:
      return 'robot';
    case NotificationCategory.system:
      return 'home';
    case NotificationCategory.activityLog:
      return 'robot';
  }
}

_NotifVisual _visuals(NotificationSeverity severity) {
  switch (severity) {
    case NotificationSeverity.critical:
      return const _NotifVisual(AppColors.error, Icons.error_outline);
    case NotificationSeverity.warning:
      return const _NotifVisual(AppColors.warning, Icons.warning_amber_rounded);
    case NotificationSeverity.info:
      return const _NotifVisual(AppColors.success, Icons.info_outline);
  }
}

String _categoryLabel(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.sensorAlert:
      return 'تنبيه مستشعر';
    case NotificationCategory.robotStatus:
      return 'حالة الروبوت';
    case NotificationCategory.system:
      return 'النظام';
    case NotificationCategory.activityLog:
      return 'سجل نشاط';
  }
}

String _timeLabel(DateTime timestamp) {
  final now = DateTime.now();
  final diff = now.difference(timestamp);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  return 'قبل ${diff.inDays} ي';
}

class _NotifVisual {
  const _NotifVisual(this.color, this.icon);

  final Color color;
  final IconData icon;
}
