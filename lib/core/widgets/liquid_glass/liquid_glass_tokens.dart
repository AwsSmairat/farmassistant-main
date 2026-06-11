// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: liquid_glass_tokens.dart
// المسار: core/widgets/liquid_glass/liquid_glass_tokens.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • liquid_glass_tokens
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// Visual constants for liquid / frosted-glass UI. Uses existing [AppColors] only.
abstract final class LiquidGlassTokens {
  LiquidGlassTokens._();

  /// حقل: blur strong.
  static const double blurStrong = 22;
  /// حقل: blur medium.
  static const double blurMedium = 14;
  /// حقل: blur soft.
  static const double blurSoft = 10;

  /// حقل: radius lg.
  static const double radiusLg = 20;
  /// حقل: radius md.
  static const double radiusMd = 16;
  /// حقل: radius sm.
  static const double radiusSm = 12;

  /// Frosted fill over content behind the glass.
  /// حقل: fill alpha سطح.
  static const double fillAlphaSurface = 0.42;
  /// حقل: fill alpha variant.
  static const double fillAlphaVariant = 0.36;

  /// حقل: border alpha.
  static const double borderAlpha = 0.22;
  /// حقل: border alpha accent.
  static const double borderAlphaAccent = 0.28;
}
