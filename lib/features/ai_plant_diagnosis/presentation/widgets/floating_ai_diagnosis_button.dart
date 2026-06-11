// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: floating_ai_diagnosis_button.dart
// المسار: features/ai_plant_diagnosis/presentation/widgets/floating_ai_diagnosis_button.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: تشخيص النبات بالذكاء الاصطناعي. عنصر واجهة قابل لإعادة الاستخدام.
//
// ماذا بداخله؟
//   • FloatingAiDiagnosisButton
//   • _FloatingAiDiagnosisButtonState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
/// مكوّن واجهة: عائم الذكاء الاصطناعي التشخيص زر.
class FloatingAiDiagnosisButton extends StatefulWidget {
  /// دالة عائم الذكاء الاصطناعي التشخيص زر.
  const FloatingAiDiagnosisButton({super.key, required this.onPressed});

  /// حقل: on pressed.
  final VoidCallback onPressed;

  @override
  /// ينشئ الحالة.
  State<FloatingAiDiagnosisButton> createState() =>
    /// دالة داخلية: عائم الذكاء الاصطناعي التشخيص زر الحالة.
      _FloatingAiDiagnosisButtonState();
}

/// حالة واجهة عائم الذكاء الاصطناعي التشخيص زر.
class _FloatingAiDiagnosisButtonState extends State<FloatingAiDiagnosisButton>
    with TickerProviderStateMixin {
  /// حقل: diameter.
  static const double _diameter = 64;

  /// حقل: pulse.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  /// حقل: glow.
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat(reverse: true);

  @override
  /// ينظف الموارد.
  void dispose() {
    _pulse.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulse, _glow]),
      builder: (context, _) {
        final pulseT = CurvedAnimation(parent: _pulse, curve: Curves.easeInOut);
        final scale = 1.0 + pulseT.value * 0.06;
        final glowT = CurvedAnimation(
          parent: _glow,
          curve: Curves.easeInOutCubic,
        );
        final glow = 0.35 + glowT.value * 0.45;

        // Outer circle carries only the soft shadow so blur is never "square".
        final outerShadows = <BoxShadow>[
        /// دالة box shadow.
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.32 * glow),
            blurRadius: 26 * glow,
            spreadRadius: 1,
          ),
        /// دالة box shadow.
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.1 * glow),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ];

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: _diameter,
            height: _diameter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: outerShadows,
              ),
              child: Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onPressed,
                  child: Ink(
                    width: _diameter,
                    height: _diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryLight.withValues(alpha: 0.95),
                          AppColors.primaryDark.withValues(alpha: 0.92),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(
                          alpha: 0.55 + glow * 0.2,
                        ),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      /// دالة صف.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          /// دالة أيقونة.
                            Icon(
                              Icons.document_scanner_rounded,
                              size: 18,
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.95,
                              ),
                            ),
                            /// دالة sized box.
                            const SizedBox(width: 2),
                          /// دالة أيقونة.
                            Icon(
                              Icons.grass_rounded,
                              size: 16,
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.92,
                              ),
                            ),
                          ],
                        ),
                        /// دالة sized box.
                        const SizedBox(height: 2),
                      /// دالة نص.
                        Text(
                          'AI',
                          style: TextStyle(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 0.6,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
