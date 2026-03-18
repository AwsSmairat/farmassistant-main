import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// App header: optional logo, title (with optional accent part), and subtitle.
/// E.g. "AgriPulse" (orange) + " Admin" (white) and "Secure gateway...".
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.logo,
    required this.title,
    this.titleAccent,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  /// Optional widget (e.g. CircleAvatar with icon).
  final Widget? logo;
  /// Main title text (displayed in white if [titleAccent] is set, else full title).
  final String title;
  /// Optional part of title in primary color (e.g. "AgriPulse").
  final String? titleAccent;
  /// Subtitle below title.
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logo != null) ...[
          logo!,
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (titleAccent != null) ...[
              Text(
                titleAccent!,
                style: (titleStyle ?? const TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
              ),
              Text(
                title,
                style: titleStyle ?? const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              Text(
                title,
                style: titleStyle ?? const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: subtitleStyle ?? const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
