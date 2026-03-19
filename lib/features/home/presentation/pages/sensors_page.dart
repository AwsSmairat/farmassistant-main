import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Sensors feature placeholder. Full UI to be implemented.
class SensorsPage extends StatelessWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('المستشعرات'),
      ),
      body: const Center(
        child: Text(
          'المستشعرات',
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
