import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../cubit/login_cubit.dart';
import '../widgets/google_profile_completion_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberSession = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().signInWithIdentifier(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
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
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
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
                    const SizedBox(height: 32),
                    LiquidGlassPanel(
                      borderRadius: LiquidGlassTokens.radiusSm,
                      blurSigma: LiquidGlassTokens.blurMedium,
                      padding: const EdgeInsets.all(16),
                      child: const AppStatusIndicator(label: 'SYSTEM ONLINE'),
                    ),
                    const SizedBox(height: 28),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberSession,
                              onChanged: (v) => setState(() => _rememberSession = v ?? false),
                              activeColor: AppColors.primary,
                              fillColor: WidgetStateProperty.resolveWith((_) => AppColors.surface),
                            ),
                            Text(
                              'تذكر الجلسة',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        AppTextLink(
                          label: 'نسيت كلمة المرور؟',
                          onPressed: () => context.push('/forgot-password'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppPrimaryButton(
                      label: 'تسجيل الدخول',
                      trailingIcon: true,
                      icon: Icons.arrow_forward,
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'SECURE PROTOCOLS',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 12),
                    AppSecondaryButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: isLoading ? null : () => context.read<LoginCubit>().signInWithGoogle(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ليس لديك حساب؟ ', style: Theme.of(context).textTheme.bodyMedium),
                        AppTextLink(
                          label: 'إنشاء حساب',
                          onPressed: () => context.push('/signup'),
                        ),
                      ],
                    ),
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
