import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Card for KPI/data: icon, label, value, optional trend (+2%, -5%) or status text.
class AppDataCard extends StatelessWidget {
  const AppDataCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor = AppColors.primary,
    this.trend,
    this.trendPositive = true,
    this.statusLabel,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color iconColor;
  /// e.g. "+2%" or "-5%"
  final String? trend;
  final bool trendPositive;
  /// e.g. "Stable"
  final String? statusLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (trend != null)
                    Text(
                      trend!,
                      style: TextStyle(
                        color: trendPositive ? AppColors.success : AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (statusLabel != null)
                    Text(
                      statusLabel!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
