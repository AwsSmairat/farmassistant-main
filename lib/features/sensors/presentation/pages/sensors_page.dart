// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: sensors_page.dart
// المسار: features/sensors/presentation/pages/sensors_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • SensorsPage
//   • _SensorsView
//   • _SoilMoistureCheckButton
//   • _SensorsHeader
//   • _RobotStatusBadge
//   • _BottomInfoBar
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../cubit/sensors_cubit.dart';
import '../cubit/sensors_state.dart';
import '../widgets/glass_sensor_card.dart';
/// شاشة المستشعرات.
class SensorsPage extends StatelessWidget {
  /// دالة المستشعرات صفحة.
  const SensorsPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SensorsCubit>()..start(),
      child: const _SensorsView(),
    );
  }
}

/// مكوّن واجهة: المستشعرات عرض.
class _SensorsView extends StatelessWidget {
  /// دالة داخلية: المستشعرات عرض.
  const _SensorsView();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<SensorsCubit, SensorsState>(
          builder: (context, state) {
            if (state is SensorsLoading || state is SensorsInitial) {
              /// دالة center.
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is SensorsFailure) {
              /// دالة center.
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (state is! SensorsReady) {
              return const SizedBox.shrink();
            }

            final snap = state.snapshot;
            final formattedTime =
                '${snap.updatedAt.hour.toString().padLeft(2, '0')}:${snap.updatedAt.minute.toString().padLeft(2, '0')}';
            final crossAxisCount = AppBreakpoints.sensorsGridCrossAxisCount(
              MediaQuery.sizeOf(context).width,
            );

            /// دالة custom scroll عرض.
            return CustomScrollView(
              slivers: [
              /// دالة sliver padding.
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: _SensorsHeader(robotOnline: snap.robotOnline),
                  ),
                ),
              /// دالة sliver padding.
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: crossAxisCount >= 3 ? 1.05 : 0.92,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        /// دالة زجاج المستشعر بطاقة.
                        return GlassSensorCard(tile: state.tiles[index]);
                      },
                      childCount: state.tiles.length,
                    ),
                  ),
                ),
              /// دالة sliver to box adapter.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: _SoilMoistureCheckButton(
                      loading: false,
                      enabled: state.isMonitoringEnabled,
                      onPressed: () => context.read<SensorsCubit>().toggleMonitoring(),
                    ),
                  ),
                ),
              /// دالة sliver to box adapter.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: _RobotLocationMap(
                      latitude: snap.latitude,
                      longitude: snap.longitude,
                    ),
                  ),
                ),
              /// دالة sliver to box adapter.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    child: _BottomInfoBar(
                      updatedTime: formattedTime,
                      robotOnline: snap.robotOnline,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// مكوّن واجهة: soil رطوبة check زر.
class _SoilMoistureCheckButton extends StatelessWidget {
  /// دالة داخلية: soil رطوبة check زر.
  const _SoilMoistureCheckButton({
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  /// حقل: تحميل.
  final bool loading;
  /// حقل: enabled.
  final bool enabled;
  /// حقل: on pressed.
  final VoidCallback? onPressed;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface.withValues(alpha: 0.36),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
        ),
        icon: loading
            /// دالة sized box.
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                enabled ? Icons.power_settings_new : Icons.play_arrow_rounded,
                size: 18,
                color: AppColors.primary,
              ),
        label: Text(
          loading ? '...' : 'فحص رطوبة التربة',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

/// كلاس المستشعرات رأس.
class _SensorsHeader extends StatelessWidget {
  /// دالة داخلية: المستشعرات رأس.
  const _SensorsHeader({required this.robotOnline});

  /// حقل: الروبوت متصل.
  final bool robotOnline;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// دالة expanded.
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /// دالة نص.
              Text(
                'Sensors Dashboard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            /// دالة sized box.
              SizedBox(height: 4),
            /// دالة نص.
              Text(
                'لوحة المستشعرات',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      /// دالة داخلية: الروبوت الحالة badge.
        _RobotStatusBadge(online: robotOnline),
      ],
    );
  }
}

/// كلاس الروبوت الحالة badge.
class _RobotStatusBadge extends StatelessWidget {
  /// دالة داخلية: الروبوت الحالة badge.
  const _RobotStatusBadge({required this.online});

  /// حقل: متصل.
  final bool online;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final color = online ? AppColors.success : AppColors.error;
    final label = online ? 'متصل' : 'غير متصل';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        /// دالة أيقونة.
          Icon(
            online ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: color,
          ),
          /// دالة sized box.
          const SizedBox(width: 8),
        /// دالة نص.
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// مكوّن واجهة: سفلي info شريط.
class _BottomInfoBar extends StatelessWidget {
  /// دالة داخلية: سفلي info شريط.
  const _BottomInfoBar({
    required this.updatedTime,
    required this.robotOnline,
  });

  /// حقل: updated time.
  final String updatedTime;
  /// حقل: الروبوت متصل.
  final bool robotOnline;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          /// دالة أيقونة.
          const Icon(Icons.update, color: AppColors.textSecondary, size: 18),
          /// دالة sized box.
          const SizedBox(width: 8),
        /// دالة expanded.
          Expanded(
            child: Text(
              'آخر تحديث: $updatedTime · ${robotOnline ? 'البث مباشر' : 'بدون اتصال'}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// كلاس الروبوت location map.
class _RobotLocationMap extends StatelessWidget {
  /// دالة داخلية: الروبوت location map.
  const _RobotLocationMap({
    required this.latitude,
    required this.longitude,
  });

  /// حقل: latitude.
  final double latitude;
  /// حقل: longitude.
  final double longitude;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);
    return LiquidGlassPanel(
      borderRadius: 14,
      blurSigma: LiquidGlassTokens.blurMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// دالة padding.
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
              /// دالة أيقونة.
                Icon(Icons.map_outlined, color: AppColors.info, size: 18),
              /// دالة sized box.
                SizedBox(width: 8),
              /// دالة نص.
                Text(
                  'موقع الروبوت (GPS)',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        /// دالة sized box.
          SizedBox(
            height: 180,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: position,
                initialZoom: 17,
              ),
              children: [
              /// دالة tile layer.
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.farmassistant.app',
                ),
              /// دالة marker layer.
                MarkerLayer(
                  markers: [
                  /// دالة marker.
                    Marker(
                      width: 52,
                      height: 52,
                      point: position,
                      child: const Icon(
                        Icons.smart_toy,
                        color: AppColors.primary,
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        /// دالة padding.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Text(
              'Lat: ${latitude.toStringAsFixed(5)} , Lng: ${longitude.toStringAsFixed(5)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
