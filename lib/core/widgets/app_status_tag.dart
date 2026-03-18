import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Small status tag (e.g. ONLINE, CHARGING, MAINTENANCE, OFFLINE).
class AppStatusTag extends StatelessWidget {
  const AppStatusTag({
    super.key,
    required this.label,
    this.variant = AppStatusTagVariant.success,
  });

  final String label;
  final AppStatusTagVariant variant;

  static Color _colorFor(AppStatusTagVariant v) {
    switch (v) {
      case AppStatusTagVariant.success:
        return AppColors.success;
      case AppStatusTagVariant.error:
        return AppColors.error;
      case AppStatusTagVariant.warning:
        return AppColors.warning;
      case AppStatusTagVariant.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

enum AppStatusTagVariant { success, error, warning, info }
