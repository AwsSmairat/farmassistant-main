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
    builder: (dialogContext) => AlertDialog(
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
            Navigator.of(dialogContext).pop();
            onCancel();
          },
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: () {
            final messenger = ScaffoldMessenger.maybeOf(dialogContext);
            void snack(String msg) {
              messenger?.showSnackBar(SnackBar(content: Text(msg)));
            }

            if (usernameController.text.trim().isEmpty) {
              snack('أدخل اسم المستخدم');
              return;
            }
            if (phoneController.text.trim().isEmpty) {
              snack('أدخل رقم الهاتف');
              return;
            }
            if (passwordController.text.isEmpty) {
              snack('أدخل كلمة المرور');
              return;
            }
            Navigator.of(dialogContext).pop();
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
