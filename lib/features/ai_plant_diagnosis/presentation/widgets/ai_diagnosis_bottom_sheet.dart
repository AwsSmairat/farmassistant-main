// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_bottom_sheet.dart
// المسار: features/ai_plant_diagnosis/presentation/widgets/ai_diagnosis_bottom_sheet.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • AiDiagnosisBottomSheet
//   • _AiDiagnosisBottomSheetBody
//   • _ImageSourceRow
//   • _GlassMiniButton
//   • _ImagePreviewCard
//   • _PreviewImage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_surface.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass_tokens.dart';
import '../../domain/entities/plant_diagnosis_result.dart';
import '../cubit/ai_plant_diagnosis_cubit.dart';
import '../cubit/ai_plant_diagnosis_state.dart';
/// كلاس الذكاء الاصطناعي التشخيص سفلي لوحة.
class AiDiagnosisBottomSheet extends StatelessWidget {
  /// دالة الذكاء الاصطناعي التشخيص سفلي لوحة.
  const AiDiagnosisBottomSheet({super.key});

  /// دالة show.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: 0.48),
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        /// دالة bloc provider.
        return BlocProvider(
          create: (_) => getIt<AiPlantDiagnosisCubit>(),
          child: const _AiDiagnosisBottomSheetBody(),
        );
      },
    );
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// كلاس الذكاء الاصطناعي التشخيص سفلي لوحة body.
class _AiDiagnosisBottomSheetBody extends StatelessWidget {
  /// دالة داخلية: الذكاء الاصطناعي التشخيص سفلي لوحة body.
  const _AiDiagnosisBottomSheetBody();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.92;

    return BlocListener<AiPlantDiagnosisCubit, AiPlantDiagnosisState>(
      listenWhen: (p, c) =>
          c.saveWarning != null && c.saveWarning != p.saveWarning,
      listener: (context, state) {
        final w = state.saveWarning;
        if (w == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
        /// دالة snack شريط.
          SnackBar(content: Text(w), backgroundColor: AppColors.warning),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + viewInsets),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: LiquidGlassPanel(
              borderRadius: LiquidGlassTokens.radiusLg + 4,
              blurSigma: LiquidGlassTokens.blurStrong,
              accentBorder: AppColors.primaryLight,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  /// دالة center.
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.textMuted.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    /// دالة نص.
                    const Text(
                      'مساعد تشخيص النبات بالذكاء الاصطناعي',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 6),
                  /// دالة نص.
                    Text(
                      'ارفع صورة واضحة لأوراق النبات أو الثمار للحصول على تقييم أولي وعلاج مقترح.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.95),
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 16),
                    BlocBuilder<AiPlantDiagnosisCubit, AiPlantDiagnosisState>(
                      builder: (context, state) {
                        /// دالة column.
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          /// دالة داخلية: الصورة source صف.
                            _ImageSourceRow(
                              enabled:
                                  state.phase !=
                                  AiPlantDiagnosisPhase.analyzing,
                              onGallery: () => context
                                  .read<AiPlantDiagnosisCubit>()
                                  .pickFromGallery(),
                              onCamera: () => context
                                  .read<AiPlantDiagnosisCubit>()
                                  .pickFromCamera(),
                            ),
                            /// دالة sized box.
                            const SizedBox(height: 14),
                          /// دالة داخلية: الصورة preview بطاقة.
                            _ImagePreviewCard(state: state),
                            /// دالة sized box.
                            const SizedBox(height: 14),
                          /// دالة داخلية: تحليل زر.
                            _AnalyzeButton(state: state),
                            /// دالة sized box.
                            const SizedBox(height: 14),
                          /// دالة داخلية: نتيجة section.
                            _ResultSection(state: state),
                            if (state.phase ==
                                AiPlantDiagnosisPhase.awaitingImage) ...[
                              /// دالة sized box.
                              const SizedBox(height: 8),
                              /// دالة داخلية: empty hint.
                              const _EmptyHint(),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// كلاس الصورة source صف.
class _ImageSourceRow extends StatelessWidget {
  /// دالة داخلية: الصورة source صف.
  const _ImageSourceRow({
    required this.onGallery,
    required this.onCamera,
    required this.enabled,
  });

  /// حقل: on gallery.
  final VoidCallback onGallery;
  /// حقل: on الكاميرا.
  final VoidCallback onCamera;
  /// حقل: enabled.
  final bool enabled;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Row(
      children: [
      /// دالة expanded.
        Expanded(
          child: _GlassMiniButton(
            icon: Icons.photo_library_outlined,
            label: 'اختيار صورة من المعرض',
            onTap: enabled ? onGallery : null,
          ),
        ),
        /// دالة sized box.
        const SizedBox(width: 10),
      /// دالة expanded.
        Expanded(
          child: _GlassMiniButton(
            icon: Icons.photo_camera_outlined,
            label: 'التقاط صورة بالكاميرا',
            onTap: enabled ? onCamera : null,
          ),
        ),
      ],
    );
  }
}

/// مكوّن واجهة: زجاج mini زر.
class _GlassMiniButton extends StatelessWidget {
  /// دالة داخلية: زجاج mini زر.
  const _GlassMiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: label.
  final String label;
  /// حقل: on tap.
  final VoidCallback? onTap;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return LiquidGlassPanel(
      borderRadius: 14,
      blurSigma: LiquidGlassTokens.blurSoft,
      accentBorder: disabled ? AppColors.border : AppColors.primary,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              children: [
              /// دالة أيقونة.
                Icon(
                  icon,
                  size: 20,
                  color: disabled ? AppColors.textMuted : AppColors.primary,
                ),
                /// دالة sized box.
                const SizedBox(width: 8),
              /// دالة expanded.
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: disabled
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مكوّن واجهة: الصورة preview بطاقة.
class _ImagePreviewCard extends StatelessWidget {
  /// دالة داخلية: الصورة preview بطاقة.
  const _ImagePreviewCard({required this.state});

  /// حقل: الحالة.
  final AiPlantDiagnosisState state;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final image = state.image;
    if (image == null) {
      return LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        child: Row(
          children: [
          /// دالة أيقونة.
            Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textMuted.withValues(alpha: 0.9),
            ),
            /// دالة sized box.
            const SizedBox(width: 10),
            /// دالة expanded.
            const Expanded(
              child: Text(
                'لم يتم اختيار صورة بعد.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      accentBorder: AppColors.primary.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        /// دالة clip rrect.
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: _PreviewImage(image: image),
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 10),
        /// دالة صف.
          Row(
            children: [
              TextButton.icon(
                onPressed: state.phase == AiPlantDiagnosisPhase.analyzing
                    ? null
                    : () => context.read<AiPlantDiagnosisCubit>().clearImage(),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('إزالة الصورة'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
              /// دالة spacer.
              const Spacer(),
              TextButton.icon(
                onPressed: state.phase == AiPlantDiagnosisPhase.analyzing
                    ? null
                    : () => _showChangeSheet(context),
                icon: const Icon(Icons.sync_alt, size: 18),
                label: const Text('تغيير الصورة'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// دالة داخلية: show change لوحة.
  Future<void> _showChangeSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        /// دالة padding.
        return Padding(
          padding: const EdgeInsets.all(12),
          child: LiquidGlassPanel(
            borderRadius: LiquidGlassTokens.radiusMd,
            blurSigma: LiquidGlassTokens.blurStrong,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              /// دالة list tile.
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('من المعرض', textAlign: TextAlign.right),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<AiPlantDiagnosisCubit>().pickFromGallery();
                  },
                ),
              /// دالة list tile.
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('بالكاميرا', textAlign: TextAlign.right),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.read<AiPlantDiagnosisCubit>().pickFromCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// كلاس preview الصورة.
class _PreviewImage extends StatelessWidget {
  /// دالة داخلية: preview الصورة.
  const _PreviewImage({required this.image});

  /// حقل: الصورة.
  final XFile image;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: image.readAsBytes(),
      builder: (context, snap) {
        if (!snap.hasData) {
          /// دالة colored box.
          return const ColoredBox(
            color: AppColors.surface,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return Image.memory(
          snap.data!,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      },
    );
  }
}

/// مكوّن واجهة: تحليل زر.
class _AnalyzeButton extends StatelessWidget {
  /// دالة داخلية: تحليل زر.
  const _AnalyzeButton({required this.state});

  /// حقل: الحالة.
  final AiPlantDiagnosisState state;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final busy = state.phase == AiPlantDiagnosisPhase.analyzing;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.92),
            AppColors.primaryDark.withValues(alpha: 0.88),
          ],
        ),
        boxShadow: [
        /// دالة box shadow.
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: (!busy && state.hasImage)
              ? () => context.read<AiPlantDiagnosisCubit>().analyze()
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy) ...[
                  /// دالة sized box.
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  /// دالة sized box.
                  const SizedBox(width: 10),
                ] else ...[
                /// دالة أيقونة.
                  Icon(
                    Icons.auto_awesome,
                    color: AppColors.textOnPrimary.withValues(alpha: 0.95),
                  ),
                  /// دالة sized box.
                  const SizedBox(width: 8),
                ],
              /// دالة نص.
                Text(
                  busy ? 'جاري التحليل…' : 'تحليل الصورة',
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// كلاس نتيجة section.
class _ResultSection extends StatelessWidget {
  /// دالة داخلية: نتيجة section.
  const _ResultSection({required this.state});

  /// حقل: الحالة.
  final AiPlantDiagnosisState state;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    if (state.phase == AiPlantDiagnosisPhase.analyzing) {
      return LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        padding: const EdgeInsets.all(18),
        child: const Row(
          children: [
          /// دالة sized box.
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          /// دالة sized box.
            SizedBox(width: 14),
          /// دالة expanded.
            Expanded(
              child: Text(
                'جاري تحليل الصورة بواسطة الذكاء الاصطناعي',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.phase == AiPlantDiagnosisPhase.error &&
        state.errorMessage != null) {
      return LiquidGlassPanel(
        borderRadius: LiquidGlassTokens.radiusSm,
        blurSigma: LiquidGlassTokens.blurSoft,
        accentBorder: AppColors.error,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// دالة أيقونة.
            const Icon(Icons.error_outline, color: AppColors.error),
            /// دالة sized box.
            const SizedBox(width: 10),
          /// دالة expanded.
            Expanded(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (state.phase == AiPlantDiagnosisPhase.success && state.result != null) {
      final r = state.result!;
      return _SuccessResultCard(result: r);
    }

    return const SizedBox.shrink();
  }
}

/// مكوّن واجهة: success نتيجة بطاقة.
class _SuccessResultCard extends StatelessWidget {
  /// دالة داخلية: success نتيجة بطاقة.
  const _SuccessResultCard({required this.result});

  /// حقل: نتيجة.
  final PlantDiagnosisResult result;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final accent = result.isDiseased ? AppColors.warning : AppColors.success;
    final statusAr = switch (result.condition) {
      PlantDiagnosisCondition.diseased => 'مصاب (Diseased)',
      PlantDiagnosisCondition.noPathogenDetected => 'لم يُكتشف مرض',
      PlantDiagnosisCondition.healthy => 'سليم (Healthy)',
    };

    return LiquidGlassPanel(
      borderRadius: LiquidGlassTokens.radiusSm,
      blurSigma: LiquidGlassTokens.blurSoft,
      accentBorder: accent,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        /// دالة صف.
          Row(
            children: [
            /// دالة أيقونة.
              Icon(Icons.verified_outlined, color: accent),
              /// دالة sized box.
              const SizedBox(width: 8),
              /// دالة نص.
              const Text(
                'نتيجة التحليل',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          /// دالة sized box.
          const SizedBox(height: 12),
        /// دالة داخلية: kv.
          _kv('الحالة', statusAr),
          if (result.isDiseased && (result.displayDiseaseName?.isNotEmpty ?? false))
          /// دالة داخلية: kv.
            _kv('اسم المرض', result.displayDiseaseName!),
          if (result.isNoPathogenDetected)
          /// دالة داخلية: kv.
            _kv('الملاحظة', 'لم يتم اكتشاف مرض واضح على الصورة.'),
        /// دالة داخلية: kv.
          _kv('نسبة الثقة', '${(result.confidence * 100).toStringAsFixed(0)}٪'),
        /// دالة داخلية: kv.
          _kv('العلاج المقترح', result.treatmentAr),
          if (result.explanation.trim().isNotEmpty)
          /// دالة داخلية: kv.
            _kv('الشرح', result.explanation.trim()),
        /// دالة داخلية: kv.
          _kv('وقت التحليل', _formatAnalyzedAt(result.analyzedAt)),
        ],
      ),
    );
  }

  /// دالة داخلية: kv.
  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        /// دالة نص.
          Text(
            k,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 3),
        /// دالة نص.
          Text(
            v,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  /// دالة داخلية: format analyzed at.
  String _formatAnalyzedAt(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    final h = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$y/$m/$day  $h:$min';
  }
}

/// كلاس empty hint.
class _EmptyHint extends StatelessWidget {
  /// دالة داخلية: empty hint.
  const _EmptyHint();

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Text(
      'اختر صورة من المعرض أو التقط صورة، ثم اضغط «تحليل الصورة».',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textMuted.withValues(alpha: 0.95),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
