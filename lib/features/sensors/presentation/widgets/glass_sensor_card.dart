import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../domain/entities/sensor_health.dart';
import '../mappers/sensors_ui_mapper.dart';

/// Sensor tile with shared liquid-glass panel; status tint only on the border.
class GlassSensorCard extends StatelessWidget {
  const GlassSensorCard({
    super.key,
    required this.tile,
    this.footer,
  });

  final SensorTileVm tile;
  final Widget? footer;

  static Color _accent(SensorHealth h) {
    switch (h) {
      case SensorHealth.good:
        return AppColors.success;
      case SensorHealth.warning:
        return AppColors.warning;
      case SensorHealth.critical:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent(tile.health);
    return Material(
      color: Colors.transparent,
      child: LiquidGlassPanel(
        borderRadius: 16,
        blurSigma: LiquidGlassTokens.blurSoft,
        accentBorder: accent,
        accentBorderWidth: 1,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tile.icon, color: accent, size: 22),
                ),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.45),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tile.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tile.value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (tile.hint != null) ...[
              const SizedBox(height: 8),
              Text(
                tile.hint!,
                style: TextStyle(
                  color: accent.withValues(alpha: 0.95),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: 10),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
