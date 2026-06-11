// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_page.dart
// المسار: features/profile/presentation/pages/privacy_policy_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • PrivacyPolicyPage
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../cubit/privacy_policy_cubit.dart';
import '../cubit/privacy_policy_state.dart';
/// شاشة الخصوصية السياسة.
class PrivacyPolicyPage extends StatelessWidget {
  /// دالة الخصوصية السياسة صفحة.
  const PrivacyPolicyPage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrivacyPolicyCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: LiquidGlassAppBar(
          title: const Text('سياسة الخصوصية'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
          builder: (context, state) {
            if (state is PrivacyPolicyLoading || state is PrivacyPolicyInitial) {
              /// دالة center.
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is PrivacyPolicyFailure) {
              /// دالة center.
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }
            final content = state is PrivacyPolicyLoaded ? state.content : '';
            /// دالة padding.
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  content.isEmpty ? 'لا توجد سياسة خصوصية حالياً.' : content,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
