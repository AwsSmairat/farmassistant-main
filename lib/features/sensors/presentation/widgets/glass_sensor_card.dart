// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: glass_sensor_card.dart
// المسار: features/sensors/presentation/widgets/glass_sensor_card.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المستشعرات. عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • GlassSensorCard
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../domain/entities/sensor_health.dart';
import '../mappers/sensors_ui_mapper.dart';
/// مكوّن واجهة: زجاج المستشعر بطاقة.
class GlassSensorCard extends StatelessWidget {
  /// دالة زجاج المستشعر بطاقة.
  const GlassSensorCard({
    super.key,
    required this.tile,
    this.footer,
  });

  /// حقل: tile.
  final SensorTileVm tile;
  /// حقل: footer.
  final Widget? footer;

  /// دالة داخلية: accent.
  static Color _accent(SensorHealth h) {
  /// دالة switch.
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
  /// يبني شجرة الواجهة (Widget).
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
          /// دالة صف.
            Row(
              children: [
              /// دالة container.
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tile.icon, color: accent, size: 22),
                ),
                /// دالة spacer.
                const Spacer(),
              /// دالة container.
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                    /// دالة box shadow.
                      BoxShadow(
                        color: accent.withValues(alpha: 0.45),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            /// دالة sized box.
            const SizedBox(height: 12),
          /// دالة نص.
            Text(
              tile.title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            /// دالة sized box.
            const SizedBox(height: 6),
          /// دالة نص.
            Text(
              tile.value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (tile.hint != null) ...[
              /// دالة sized box.
              const SizedBox(height: 8),
            /// دالة نص.
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
              /// دالة sized box.
              const SizedBox(height: 10),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
