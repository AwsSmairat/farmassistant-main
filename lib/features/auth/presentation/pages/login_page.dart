import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../domain/entities/auth_user.dart';
import '../cubit/login_cubit.dart';

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

  void _showGoogleProfileDialog(BuildContext context, AuthUser user) {
    final usernameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('أكمل بياناتك'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  hintText: 'username',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '+962 7XXXXXXXX',
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  hintText: '••••••••',
                ),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<LoginCubit>().cancelGoogleProfile();
            },
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (usernameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أدخل اسم المستخدم')),
                );
                return;
              }
              if (phoneController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أدخل رقم الهاتف')),
                );
                return;
              }
              if (passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أدخل كلمة المرور')),
                );
                return;
              }
              Navigator.of(ctx).pop();
              context.read<LoginCubit>().completeGoogleProfile(
                    user: user,
                    username: usernameController.text.trim(),
                    phone: phoneController.text.trim(),
                    password: passwordController.text,
                  );
            },
            child: const Text('التالي'),
          ),
        ],
      ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'حدث خطأ'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            final googleUser = state.user;
            if (state.status == LoginStatus.googleSignInNeedsProfile &&
                googleUser != null) {
              _showGoogleProfileDialog(context, googleUser);
            }
            if (state.status == LoginStatus.success) {
              context.go('/');
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
