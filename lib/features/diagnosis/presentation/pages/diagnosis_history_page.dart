// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: diagnosis_history_page.dart
// المسار: features/diagnosis/presentation/pages/diagnosis_history_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: سجل تشخيص النبات. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • DiagnosisHistoryPage
//   • _relativeArabic()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../cubit/diagnosis_history_cubit.dart';
import '../cubit/diagnosis_history_state.dart';
/// شاشة التشخيص السجل.
class DiagnosisHistoryPage extends StatelessWidget {
  /// دالة التشخيص السجل صفحة.
  const DiagnosisHistoryPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        title: const Text('سجل التشخيص'),
      ),
      body: BlocBuilder<DiagnosisHistoryCubit, DiagnosisHistoryState>(
        builder: (context, state) {
          if (state is DiagnosisHistoryLoading || state is DiagnosisHistoryInitial) {
            /// دالة center.
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is DiagnosisHistoryFailure) {
            /// دالة center.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  /// دالة نص.
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 16),
                  /// دالة نص زر.
                    TextButton(
                      onPressed: () =>
                          context.read<DiagnosisHistoryCubit>().start(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }
          final records = (state as DiagnosisHistoryReady).records;
          if (records.isEmpty) {
            /// دالة center.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: LiquidGlassPanel(
                  borderRadius: LiquidGlassTokens.radiusSm,
                  blurSigma: LiquidGlassTokens.blurSoft,
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'لا توجد سجلات تشخيص بعد.\nعند توفر بيانات في مجموعة ai_diagnosis ستظهر هنا تلقائياً.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: records.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final r = records[index];
              final color = r.isHealthy ? AppColors.success : AppColors.warning;
              final pct = (r.confidence * 100).clamp(0, 100).toStringAsFixed(0);
              /// دالة زجاجي زجاج لوحة.
              return LiquidGlassPanel(
                borderRadius: LiquidGlassTokens.radiusSm,
                blurSigma: LiquidGlassTokens.blurSoft,
                accentBorder: color,
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  /// دالة container.
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withValues(alpha: 0.35)),
                      ),
                      child: Icon(
                        r.isHealthy
                            ? Icons.verified_outlined
                            : Icons.warning_amber_rounded,
                        color: color,
                        size: 22,
                      ),
                    ),
                    /// دالة sized box.
                    const SizedBox(width: 12),
                  /// دالة expanded.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        /// دالة نص.
                          Text(
                            r.resultName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          /// دالة sized box.
                          const SizedBox(height: 4),
                        /// دالة نص.
                          Text(
                            'الثقة: $pct٪ · ${_relativeArabic(r.createdAt)}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (r.suggestedTreatment.isNotEmpty &&
                              r.suggestedTreatment != '—') ...[
                            /// دالة sized box.
                            const SizedBox(height: 8),
                          /// دالة نص.
                            Text(
                              r.suggestedTreatment,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  /// دالة أيقونة.
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textMuted.withValues(alpha: 0.9),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// دالة داخلية: relative arabic.
String _relativeArabic(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} د';
  if (diff.inHours < 24) return 'قبل ${diff.inHours} س';
  return 'قبل ${diff.inDays} ي';
}
