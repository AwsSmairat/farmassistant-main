// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: notifications_page.dart
// المسار: features/notifications/presentation/pages/notifications_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: التنبيهات. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • NotificationsPage
//   • _NotificationsView
//   • _NotificationItem
//   • _NotifVisual
//   • _tabForCategory()
//   • _categoryLabel()
//   • _timeLabel()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../domain/entities/farm_notification.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

/// شاشة التنبيهات.
class NotificationsPage extends StatelessWidget {
  /// دالة التنبيهات صفحة.
  const NotificationsPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..start(),
      child: const _NotificationsView(),
    );
  }
}

/// مكوّن واجهة: التنبيهات عرض.
class _NotificationsView extends StatelessWidget {
  /// دالة داخلية: التنبيهات عرض.
  const _NotificationsView();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('Notifications'),
        actions: [
        /// دالة نص زر.
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
              /// دالة center.
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is NotificationsFailure) {
              /// دالة center.
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
              /// دالة center.
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
                /// دالة داخلية: التنبيه item.
                return _NotificationItem(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}

/// كلاس التنبيه item.
class _NotificationItem extends StatelessWidget {
  /// دالة داخلية: التنبيه item.
  const _NotificationItem({required this.item});

  /// حقل: item.
  final FarmNotification item;

  @override
  /// يبني شجرة الواجهة (Widget).
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
            /// دالة container.
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: visual.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(visual.icon, color: visual.color, size: 20),
              ),
              /// دالة sized box.
              const SizedBox(width: 10),
            /// دالة expanded.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  /// دالة صف.
                    Row(
                      children: [
                      /// دالة expanded.
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
                        /// دالة container.
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
                    /// دالة sized box.
                    const SizedBox(height: 4),
                  /// دالة نص.
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 6),
                  /// دالة صف.
                    Row(
                      children: [
                      /// دالة نص.
                        Text(
                        /// دالة داخلية: category label.
                          _categoryLabel(item.category),
                          style: TextStyle(
                            color: visual.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        /// دالة spacer.
                        const Spacer(),
                      /// دالة نص.
                        Text(
                        /// دالة داخلية: time label.
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

/// دالة داخلية: tab for category.
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

/// دالة داخلية: category label.
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

/// دالة داخلية: time label.
String _timeLabel(DateTime timestamp) {
  final now = DateTime.now();
  final diff = now.difference(timestamp);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  return 'قبل ${diff.inDays} ي';
}

/// كلاس notif visual.
class _NotifVisual {
  /// دالة داخلية: notif visual.
  const _NotifVisual(this.color, this.icon);

  /// حقل: color.
  final Color color;
  /// حقل: أيقونة.
  final IconData icon;
}
