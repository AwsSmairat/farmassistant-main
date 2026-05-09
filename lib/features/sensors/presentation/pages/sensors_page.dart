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

/// Sensors dashboard: real-time grid of farm / robot readings.
class SensorsPage extends StatelessWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SensorsCubit>()..start(),
      child: const _SensorsView(),
    );
  }
}

class _SensorsView extends StatelessWidget {
  const _SensorsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<SensorsCubit, SensorsState>(
          builder: (context, state) {
            if (state is SensorsLoading || state is SensorsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is SensorsFailure) {
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

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: _SensorsHeader(robotOnline: snap.robotOnline),
                  ),
                ),
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
                        return GlassSensorCard(tile: state.tiles[index]);
                      },
                      childCount: state.tiles.length,
                    ),
                  ),
                ),
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: _RobotLocationMap(
                      latitude: snap.latitude,
                      longitude: snap.longitude,
                    ),
                  ),
                ),
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

class _SoilMoistureCheckButton extends StatelessWidget {
  const _SoilMoistureCheckButton({
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  final bool loading;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
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

class _SensorsHeader extends StatelessWidget {
  const _SensorsHeader({required this.robotOnline});

  final bool robotOnline;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sensors Dashboard',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
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
        _RobotStatusBadge(online: robotOnline),
      ],
    );
  }
}

class _RobotStatusBadge extends StatelessWidget {
  const _RobotStatusBadge({required this.online});

  final bool online;

  @override
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
          Icon(
            online ? Icons.circle : Icons.circle_outlined,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 8),
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

class _BottomInfoBar extends StatelessWidget {
  const _BottomInfoBar({
    required this.updatedTime,
    required this.robotOnline,
  });

  final String updatedTime;
  final bool robotOnline;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.update, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 8),
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

class _RobotLocationMap extends StatelessWidget {
  const _RobotLocationMap({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);
    return LiquidGlassPanel(
      borderRadius: 14,
      blurSigma: LiquidGlassTokens.blurMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: AppColors.info, size: 18),
                SizedBox(width: 8),
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
          SizedBox(
            height: 180,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: position,
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.farmassistant.app',
                ),
                MarkerLayer(
                  markers: [
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
