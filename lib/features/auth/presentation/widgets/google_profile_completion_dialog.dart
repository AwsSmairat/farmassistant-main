import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shared dialog after Google sign-in when Firestore profile is missing.
Future<void> showGoogleProfileCompletionDialog(
  BuildContext context, {
  required void Function({
    required String username,
    required String phone,
    required String password,
  }) onSubmit,
  required VoidCallback onCancel,
}) {
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  return showDialog<void>(
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
            onCancel();
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
            onSubmit(
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
