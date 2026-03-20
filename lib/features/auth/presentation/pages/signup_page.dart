import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../cubit/signup_cubit.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignupView();
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final phoneRaw = _phoneController.text.trim().replaceAll(RegExp(r'\s'), '');
    final phone = phoneRaw.isEmpty ? '' : '+962$phoneRaw';
    context.read<SignupCubit>().createAccountWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          phone: phone,
        );
  }

  void _showVerificationDialog(BuildContext context, String email) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('تأكيد البريد الإلكتروني'),
        content: Text(
          'أرسلنا بريداً إلى $email لتأكيد حسابك.\nاضغط على الرابط في البريد ثم افتح التطبيق للمتابعة والدخول.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/');
            },
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: LiquidGlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        automaticallyImplyLeading: false,
        title: const Text('إنشاء حساب'),
      ),
      body: SafeArea(
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'حدث خطأ'),
                  backgroundColor: AppColors.error,
                ),
              );
            }
            if (state.status == SignupStatus.success && state.user != null) {
              final email = state.user!.email ?? _emailController.text.trim();
              _showVerificationDialog(context, email);
            }
          },
          builder: (context, state) {
            final isLoading = state.status == SignupStatus.loading;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _usernameController,
                      label: 'اسم المستخدم',
                      hint: 'username',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'أدخل اسم المستخدم';
                        if (v.trim().length < 2) return 'اسم المستخدم حرفين على الأقل';
                        return null;
                      },
                      autofillHints: const [AutofillHints.username],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      hint: '7XXXXXXXX',
                      prefixIcon: Icons.phone_outlined,
                      prefix: const Text(
                        '+962 ',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        final s = (v ?? '').trim().replaceAll(RegExp(r'\s'), '');
                        if (s.isEmpty) return 'أدخل رقم الهاتف';
                        if (!s.startsWith('7')) return 'رقم الأردن يبدأ بـ 7 بعد +962';
                        if (s.length != 9) return 'رقم غير صحيح (7 ثم 8 أرقام)';
                        if (!RegExp(r'^7\d{8}$').hasMatch(s)) return 'أدخل 8 أرقام بعد 7';
                        return null;
                      },
                      autofillHints: const [AutofillHints.telephoneNumber],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hint: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'أدخل البريد الإلكتروني';
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
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'أدخل كلمة المرور';
                        if (v.length < 6) return 'كلمة المرور 6 أحرف على الأقل';
                        return null;
                      },
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور',
                      hint: '••••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      validator: (v) {
                        if (v == null || v != _passwordController.text) return 'غير متطابقة';
                        return null;
                      },
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    const SizedBox(height: 28),
                    AppPrimaryButton(
                      label: 'إنشاء الحساب',
                      trailingIcon: true,
                      icon: Icons.arrow_forward,
                      onPressed: _submit,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'أو التسجيل عبر',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    AppSecondaryButton(
                      label: 'Google',
                      icon: Icons.g_mobiledata_rounded,
                      onPressed: isLoading ? null : () => context.read<SignupCubit>().signInWithGoogle(),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('لديك حساب؟ ', style: Theme.of(context).textTheme.bodyMedium),
                        AppTextLink(
                          label: 'تسجيل الدخول',
                          onPressed: () => context.pop(),
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
    );
  }
}
