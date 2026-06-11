// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: login_page.dart
// المسار: features/auth/presentation/pages/login_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • LoginPage
//   • _LoginView
//   • _LoginViewState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../cubit/login_cubit.dart';
import '../widgets/google_profile_completion_dialog.dart';

/// شاشة تسجيل الدخول.
class LoginPage extends StatelessWidget {
  /// دالة تسجيل الدخول صفحة.
  const LoginPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

/// مكوّن واجهة: تسجيل الدخول عرض.
class _LoginView extends StatefulWidget {
  /// دالة داخلية: تسجيل الدخول عرض.
  const _LoginView();

  @override
  /// ينشئ الحالة.
  State<_LoginView> createState() => _LoginViewState();
}

/// حالة واجهة تسجيل الدخول عرض.
class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberSession = false;

  @override
  /// ينظف الموارد.
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// دالة داخلية: submit.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().signInWithIdentifier(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 520,
          child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.failure) {
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              /// دالة snack شريط.
                SnackBar(
                  content: Text(state.message ?? 'حدث خطأ'),
                  backgroundColor: AppColors.error,
                ),
              );
            }

            final googleUser = state.user;
            if (state.status == LoginStatus.googleSignInNeedsProfile &&
                googleUser != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
              /// دالة show جوجل الملف الشخصي إكمال حوار.
                showGoogleProfileCompletionDialog(
                  context,
                  onSubmit: ({
                    required String username,
                    required String phone,
                    required String password,
                  }) {
                    context.read<LoginCubit>().completeGoogleProfile(
                          user: googleUser,
                          username: username,
                          phone: phone,
                          password: password,
                        );
                  },
                  onCancel: () =>
                      context.read<LoginCubit>().cancelGoogleProfile(),
                );
              });
            }

            // Avoid context.go('/') racing FirebaseAuth + GoRouter redirect (can crash / stall on web).
            if (state.status == LoginStatus.success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                GoRouter.of(context).refresh();
              });
            }
          },
          builder: (context, state) {
            final isLoading = state.status == LoginStatus.loading;
            /// دالة single child scroll عرض.
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// دالة sized box.
                    const SizedBox(height: 32),
                    /// دالة التطبيق رأس.
                    const AppHeader(
                      logo: CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.surface,
                        child: Icon(Icons.smart_toy_outlined, color: AppColors.primary, size: 40),
                      ),
                      title: '',
                      titleAccent: 'FarmAssistant',
                      subtitle: 'بوابة آمنة لإدارة المزرعة',
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 32),
                  /// دالة زجاجي زجاج لوحة.
                    LiquidGlassPanel(
                      borderRadius: LiquidGlassTokens.radiusSm,
                      blurSigma: LiquidGlassTokens.blurMedium,
                      padding: const EdgeInsets.all(16),
                      child: const AppStatusIndicator(label: 'SYSTEM ONLINE'),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 28),
                  /// دالة التطبيق نص حقل.
                    AppTextField(
                      controller: _identifierController,
                      label: 'البريد الإلكتروني أو اسم المستخدم',
                      hint: 'بريد إلكتروني / اسم مستخدم',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'أدخل البريد الإلكتروني أو اسم المستخدم';
                        }
                        return null;
                      },
                      autofillHints: const [AutofillHints.email],
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 16),
                  /// دالة التطبيق نص حقل.
                    AppTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hint: '••••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                        return null;
                      },
                      autofillHints: const [AutofillHints.password],
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 12),
                  /// دالة صف.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      /// دالة صف.
                        Row(
                          children: [
                          /// دالة checkbox.
                            Checkbox(
                              value: _rememberSession,
                              onChanged: (v) => setState(() => _rememberSession = v ?? false),
                              activeColor: AppColors.primary,
                              fillColor: WidgetStateProperty.resolveWith((_) => AppColors.surface),
                            ),
                          /// دالة نص.
                            Text(
                              'تذكر الجلسة',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      /// دالة التطبيق نص رابط.
                        AppTextLink(
                          label: 'نسيت كلمة المرور؟',
                          onPressed: () => context.push('/forgot-password'),
                        ),
                      ],
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 24),
                  /// دالة التطبيق رئيسي زر.
                    AppPrimaryButton(
                      label: 'تسجيل الدخول',
                      trailingIcon: true,
                      icon: Icons.arrow_forward,
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 24),
                  /// دالة نص.
                    Text(
                      'SECURE PROTOCOLS',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1,
                          ),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 12),
                  /// دالة التطبيق ثانوي زر.
                    AppSecondaryButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: isLoading ? null : () => context.read<LoginCubit>().signInWithGoogle(),
                    ),
                  /// دالة صف.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      /// دالة نص.
                        Text('ليس لديك حساب؟ ', style: Theme.of(context).textTheme.bodyMedium),
                      /// دالة التطبيق نص رابط.
                        AppTextLink(
                          label: 'إنشاء حساب',
                          onPressed: () => context.push('/signup'),
                        ),
                      ],
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
