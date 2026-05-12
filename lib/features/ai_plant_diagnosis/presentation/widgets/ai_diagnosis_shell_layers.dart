import 'package:flutter/material.dart';

import 'ai_diagnosis_bottom_sheet.dart';
import 'floating_ai_diagnosis_button.dart';

/// Wraps primary tab content with the floating AI entry point (phone layout).
class AiDiagnosisPhoneBodyLayer extends StatelessWidget {
  const AiDiagnosisPhoneBodyLayer({
    super.key,
    required this.child,
    this.showAiFab = false,
  });

  final Widget child;

  /// When true, shows the AI assistant FAB (intended for the dashboard tab only).
  final bool showAiFab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: child),
        if (showAiFab)
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

/// Floating AI entry point over scrollable shell content (navigation rail layout).
class AiDiagnosisWideContentLayer extends StatelessWidget {
  const AiDiagnosisWideContentLayer({
    super.key,
    required this.child,
    this.showAiFab = false,
  });

  final Widget child;

  /// When true, shows the AI assistant FAB (intended for the dashboard tab only).
  final bool showAiFab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showAiFab)
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
