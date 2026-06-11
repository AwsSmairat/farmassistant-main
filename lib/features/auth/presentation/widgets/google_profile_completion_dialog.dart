// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: google_profile_completion_dialog.dart
// المسار: features/auth/presentation/widgets/google_profile_completion_dialog.dart
// الطبقة: presentation / widgets — مكوّن واجهة
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. جزء من ميزة المصادقة وتسجيل الدخول.
//
// ماذا بداخله؟
//   • showGoogleProfileCompletionDialog()
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shared dialog after Google sign-in when Firestore profile is missing.
/// دالة show جوجل الملف الشخصي إكمال حوار.
Future<void> showGoogleProfileCompletionDialog(
  BuildContext context, {
  /// دالة function.
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
          /// دالة نص حقل.
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'اسم المستخدم',
                hintText: 'username',
              ),
              textInputAction: TextInputAction.next,
            ),
            /// دالة sized box.
            const SizedBox(height: 12),
          /// دالة نص حقل.
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
                hintText: '+962 7XXXXXXXX',
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            /// دالة sized box.
            const SizedBox(height: 12),
          /// دالة نص حقل.
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
      /// دالة نص زر.
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
          /// دالة on cancel.
            onCancel();
          },
          child: const Text('إلغاء'),
        ),
      /// دالة filled زر.
        FilledButton(
          onPressed: () {
            final messenger = ScaffoldMessenger.maybeOf(dialogContext);
            /// دالة snack.
            void snack(String msg) {
              messenger?.showSnackBar(SnackBar(content: Text(msg)));
            }

            if (usernameController.text.trim().isEmpty) {
            /// دالة snack.
              snack('أدخل اسم المستخدم');
              return;
            }
            if (phoneController.text.trim().isEmpty) {
            /// دالة snack.
              snack('أدخل رقم الهاتف');
              return;
            }
            if (passwordController.text.isEmpty) {
            /// دالة snack.
              snack('أدخل كلمة المرور');
              return;
            }
            Navigator.of(dialogContext).pop();
          /// دالة on submit.
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
