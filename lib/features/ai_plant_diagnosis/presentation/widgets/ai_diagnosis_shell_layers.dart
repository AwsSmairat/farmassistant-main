// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: ai_diagnosis_shell_layers.dart
// المسار: features/ai_plant_diagnosis/presentation/widgets/ai_diagnosis_shell_layers.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. جزء من ميزة تشخيص النبات بالذكاء الاصطناعي.
//
// ماذا بداخله؟
//   • AiDiagnosisPhoneBodyLayer
//   • AiDiagnosisWideContentLayer
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import 'ai_diagnosis_bottom_sheet.dart';
import 'floating_ai_diagnosis_button.dart';
/// كلاس الذكاء الاصطناعي التشخيص phone body layer.
class AiDiagnosisPhoneBodyLayer extends StatelessWidget {
  /// دالة الذكاء الاصطناعي التشخيص phone body layer.
  const AiDiagnosisPhoneBodyLayer({
    super.key,
    required this.child,
    this.showAiFab = false,
  });

  /// حقل: child.
  final Widget child;

  /// When true, shows the AI assistant FAB (intended for the dashboard tab only).
  /// حقل: show الذكاء الاصطناعي fab.
  final bool showAiFab;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: child),
        if (showAiFab)
        /// دالة align.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: FloatingAiDiagnosisButton(
                onPressed: () => AiDiagnosisBottomSheet.show(context),
              ),
            ),
          ),
      ],
    );
  }
}
/// كلاس الذكاء الاصطناعي التشخيص wide content layer.
class AiDiagnosisWideContentLayer extends StatelessWidget {
  /// دالة الذكاء الاصطناعي التشخيص wide content layer.
  const AiDiagnosisWideContentLayer({
    super.key,
    required this.child,
    this.showAiFab = false,
  });

  /// حقل: child.
  final Widget child;

  /// When true, shows the AI assistant FAB (intended for the dashboard tab only).
  /// حقل: show الذكاء الاصطناعي fab.
  final bool showAiFab;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showAiFab)
        /// دالة safe area.
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 18, end: 18),
                child: FloatingAiDiagnosisButton(
                  onPressed: () => AiDiagnosisBottomSheet.show(context),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
