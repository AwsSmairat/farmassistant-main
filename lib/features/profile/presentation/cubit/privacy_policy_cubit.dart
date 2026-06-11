// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_cubit.dart
// المسار: features/profile/presentation/cubit/privacy_policy_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • PrivacyPolicyCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_privacy_policy.dart';
import '../../domain/usecases/save_privacy_policy.dart';
import 'privacy_policy_state.dart';

/// منطق الواجهة (Cubit) لـ الخصوصية السياسة.
class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit(this._getPrivacyPolicy, this._savePrivacyPolicy)
      : super(const PrivacyPolicyInitial());

  /// حقل: جلب الخصوصية السياسة.
  final GetPrivacyPolicy _getPrivacyPolicy;
  /// حقل: حفظ الخصوصية السياسة.
  final SavePrivacyPolicy _savePrivacyPolicy;

  /// دالة load.
  Future<void> load() async {
  /// يصدّر حالة جديدة.
    emit(const PrivacyPolicyLoading());
    try {
      final content = await _getPrivacyPolicy();
      emit(PrivacyPolicyLoaded(content));
    } catch (e) {
      emit(PrivacyPolicyFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  /// يحفظ.
  Future<void> save(String content) async {
  /// يصدّر حالة جديدة.
    emit(PrivacyPolicySaving(content));
    try {
      await _savePrivacyPolicy(content);
      emit(PrivacyPolicyLoaded(content));
    } catch (e) {
      emit(PrivacyPolicyFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }
}
