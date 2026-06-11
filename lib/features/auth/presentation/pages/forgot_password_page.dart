// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: forgot_password_page.dart
// المسار: features/auth/presentation/pages/forgot_password_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • ForgotPasswordPage
//   • _ForgotPasswordView
//   • _ForgotPasswordViewState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../cubit/forgot_password_cubit.dart';

/// شاشة نسيت كلمة المرور.
class ForgotPasswordPage extends StatelessWidget {
  /// دالة نسيت كلمة المرور صفحة.
  const ForgotPasswordPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return const _ForgotPasswordView();
  }
}

/// مكوّن واجهة: نسيت كلمة المرور عرض.
class _ForgotPasswordView extends StatefulWidget {
  /// دالة داخلية: نسيت كلمة المرور عرض.
  const _ForgotPasswordView();

  @override
  /// ينشئ الحالة.
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

/// حالة واجهة نسيت كلمة المرور عرض.
class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  /// ينظف الموارد.
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// دالة داخلية: submit.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text.trim());
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        automaticallyImplyLeading: false,
        title: const Text('استعادة كلمة المرور'),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 480,
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state.status == ForgotPasswordStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
              /// دالة snack شريط.
                SnackBar(
                  content: Text(state.message ?? 'حدث خطأ'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            if (state.status == ForgotPasswordStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                /// دالة snack شريط.
                const SnackBar(
                  content: Text('تم إرسال رابط استعادة كلمة المرور إلى بريدك'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            final isLoading = state.status == ForgotPasswordStatus.loading;
            final isSuccess = state.status == ForgotPasswordStatus.success;
            /// دالة single child scroll عرض.
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// دالة sized box.
                    const SizedBox(height: 24),
                  /// دالة نص.
                    Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لتغيير كلمة المرور (Gmail أو iCloud).',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 32),
                  /// دالة التطبيق نص حقل.
                    AppTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'أدخل البريد الإلكتروني';
                        return null;
                      },
                      autofillHints: const [AutofillHints.email],
                      enabled: !isSuccess,
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 24),
                  /// دالة التطبيق رئيسي زر.
                    AppPrimaryButton(
                      label: 'إرسال الرابط',
                      icon: Icons.send_outlined,
                      onPressed: isSuccess ? null : _submit,
                      isLoading: isLoading,
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}
