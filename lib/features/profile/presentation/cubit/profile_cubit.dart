import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile, this._updateProfile) : super(const ProfileInitial());

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  Future<void> load() async {
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

  Future<void> updateProfile({String? username, String? phone}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

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
