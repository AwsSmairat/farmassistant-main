import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Small status indicator: colored dot + label (e.g. green dot + "SYSTEM ONLINE").
class AppStatusIndicator extends StatelessWidget {
  const AppStatusIndicator({
    super.key,
    required this.label,
    this.color = AppColors.success,
    this.dotSize = 8,
  });

  final String label;
  final Color color;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
