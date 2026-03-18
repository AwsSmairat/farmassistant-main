import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Action card button: title, optional description, icon; primary (orange) or secondary (dark).
class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.primary = false,
    this.onTap,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = primary ? AppColors.primary : AppColors.surface;
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (icon != null)
                Icon(icon, color: AppColors.textPrimary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
