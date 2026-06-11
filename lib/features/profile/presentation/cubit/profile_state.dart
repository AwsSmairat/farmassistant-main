// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_state.dart
// المسار: features/profile/presentation/cubit/profile_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • profile_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

import '../../domain/entities/profile.dart';

sealed class ProfileState extends Equatable {
  /// دالة الملف الشخصي الحالة.
  const ProfileState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  /// دالة الملف الشخصي initial.
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  /// دالة الملف الشخصي تحميل.
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  /// دالة الملف الشخصي loaded.
  const ProfileLoaded(this.profile);

  /// حقل: الملف الشخصي.
  final Profile profile;

  @override
  /// يُرجع props.
  List<Object?> get props => [profile];
}

final class ProfileUpdating extends ProfileState {
  /// دالة الملف الشخصي updating.
  const ProfileUpdating(this.profile);

  /// حقل: الملف الشخصي.
  final Profile profile;

  @override
  /// يُرجع props.
  List<Object?> get props => [profile];
}

final class ProfileFailure extends ProfileState {
  /// دالة الملف الشخصي فشل.
  const ProfileFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
