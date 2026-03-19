import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_privacy_policy.dart';
import '../../domain/usecases/save_privacy_policy.dart';
import 'privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyCubit(this._getPrivacyPolicy, this._savePrivacyPolicy)
      : super(const PrivacyPolicyInitial());

  final GetPrivacyPolicy _getPrivacyPolicy;
  final SavePrivacyPolicy _savePrivacyPolicy;

  Future<void> load() async {
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

  Future<void> save(String content) async {
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
