// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: app_text_field.dart
// المسار: core/widgets/app_text_field.dart
// الطبقة: core / widgets — مكوّنات مشتركة
//
// ماذا يفعل؟
//   جزء من البنية الأساسية للتطبيق.
//
// ماذا بداخله؟
//   • AppTextField
//   • _AppTextFieldState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Custom text field: dark background, rounded corners, optional prefix/suffix icons.
/// كلاس التطبيق نص حقل.
class AppTextField extends StatefulWidget {
  /// دالة التطبيق نص حقل.
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.obscureText = false,
    this.showObscureToggle = true,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofillHints,
    this.maxLines = 1,
  });

  /// حقل: controller.
  final TextEditingController? controller;
  /// حقل: label.
  final String? label;
  /// حقل: hint.
  final String? hint;
  /// حقل: prefix أيقونة.
  final IconData? prefixIcon;
  /// Optional text/widget shown after [prefixIcon] (e.g. fixed phone prefix "+962 ").
  /// حقل: prefix.
  final Widget? prefix;
  /// حقل: suffix أيقونة.
  final Widget? suffixIcon;
  /// حقل: obscure نص.
  final bool obscureText;
  /// حقل: show obscure تبديل.
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  /// حقل: نص input إجراء.
  final TextInputAction? textInputAction;
  /// دالة function.
  final String? Function(String?)? validator;
  /// دالة function.
  final void Function(String)? onChanged;
  /// دالة function.
  final void Function(String)? onSubmitted;
  /// حقل: enabled.
  final bool enabled;
  /// حقل: autofill hints.
  final Iterable<String>? autofillHints;
  /// حقل: max lines.
  final int maxLines;

  @override
  /// ينشئ الحالة.
  State<AppTextField> createState() => _AppTextFieldState();
}

/// حالة واجهة التطبيق نص حقل.
class _AppTextFieldState extends State<AppTextField> {
  /// حقل: obscure نص.
  late bool _obscureText;

  @override
  /// يهيّئ الويدجت.
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  /// يستجيب لتغيّر خصائص الويدجت.
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) _obscureText = widget.obscureText;
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    final showPasswordToggle = widget.obscureText && widget.showObscureToggle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
        /// دالة نص.
          Text(
            widget.label!,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 8),
        ],
      /// دالة نص form حقل.
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          autofillHints: widget.autofillHints,
          maxLines: widget.maxLines,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: widget.prefixIcon != null
                /// دالة أيقونة.
                ? Icon(widget.prefixIcon, color: AppColors.textSecondary, size: 22)
                : null,
            prefix: widget.prefix,
            suffixIcon: showPasswordToggle
                /// دالة أيقونة زر.
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
