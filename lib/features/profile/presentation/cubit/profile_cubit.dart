// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_cubit.dart
// المسار: features/profile/presentation/cubit/profile_cubit.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. إدارة الحالة والأحداث (Bloc/Cubit).
//
// ماذا بداخله؟
//   • ProfileCubit
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

/// منطق الواجهة (Cubit) لـ الملف الشخصي.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile, this._updateProfile) : super(const ProfileInitial());

  /// حقل: جلب الملف الشخصي.
  final GetProfile _getProfile;
  /// حقل: تحديث الملف الشخصي.
  final UpdateProfile _updateProfile;

  /// دالة load.
  Future<void> load() async {
  /// يصدّر حالة جديدة.
    emit(const ProfileLoading());
    try {
      final profile = await _getProfile();
      emit(ProfileLoaded(profile));
    } catch (e, _) {
      emit(ProfileFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }

  /// يحدّث الملف الشخصي.
  Future<void> updateProfile({String? username, String? phone}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

  /// يصدّر حالة جديدة.
    emit(ProfileUpdating(current.profile));
    try {
      await _updateProfile(username: username, phone: phone);
      final updated = await _getProfile();
      emit(ProfileLoaded(updated));
    } catch (e, _) {
      emit(ProfileFailure(
        e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString(),
      ));
    }
  }
}
