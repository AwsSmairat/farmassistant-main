import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/cubit/privacy_policy_cubit.dart';
import '../../../profile/presentation/cubit/privacy_policy_state.dart';

/// Admin page to manage privacy policy content.
class AdminPrivacyPolicyPage extends StatefulWidget {
  const AdminPrivacyPolicyPage({super.key});

  @override
  State<AdminPrivacyPolicyPage> createState() => _AdminPrivacyPolicyPageState();
}

class _AdminPrivacyPolicyPageState extends State<AdminPrivacyPolicyPage> {
  final TextEditingController _controller = TextEditingController();
  bool _initialized = false;
  bool _saveRequested = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PrivacyPolicyCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: const Text('إدارة سياسة الخصوصية'),
        ),
        body: BlocConsumer<PrivacyPolicyCubit, PrivacyPolicyState>(
          listener: (context, state) {
            if (state is PrivacyPolicyLoaded && !_initialized) {
              _controller.text = state.content;
              _initialized = true;
              return;
            }
            if (state is PrivacyPolicyLoaded && _saveRequested) {
              _saveRequested = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حفظ سياسة الخصوصية'),
                  backgroundColor: AppColors.surface,
                ),
              );
            }
          },
          builder: (context, state) {
            final saving = state is PrivacyPolicySaving;
            if (state is PrivacyPolicyLoading && !_initialized) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is PrivacyPolicyFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'اكتب سياسة الخصوصية هنا...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: saving
                        ? null
                        : () {
                            _saveRequested = true;
                            context.read<PrivacyPolicyCubit>().save(_controller.text);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('حفظ'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
