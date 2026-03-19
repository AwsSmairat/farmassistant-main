import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Alerts feature placeholder. Full UI to be implemented.
class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('التنبيهات'),
      ),
      body: const Center(
        child: Text(
          'التنبيهات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
