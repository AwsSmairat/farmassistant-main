import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';

/// Diagnosis/history: placeholder list until RTDB integration.
class DiagnosisHistoryPage extends StatelessWidget {
  const DiagnosisHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('سجل التشخيص'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemBuilder: (context, index) {
          final isHealthy = index % 3 != 0;
          final color = isHealthy ? AppColors.success : AppColors.warning;
          return LiquidGlassPanel(
            borderRadius: LiquidGlassTokens.radiusSm,
            blurSigma: LiquidGlassTokens.blurSoft,
            accentBorder: color,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Icon(
                    isHealthy ? Icons.verified_outlined : Icons.warning_amber_rounded,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHealthy ? 'نبات سليم' : 'اشتباه مرض فطري',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الثقة: ${isHealthy ? 93 : 78}٪ · قبل ${index + 1} ساعة',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textMuted.withValues(alpha: 0.9)),
              ],
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemCount: 8,
      ),
    );
  }
}

