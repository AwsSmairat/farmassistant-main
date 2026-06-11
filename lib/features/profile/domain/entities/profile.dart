// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile.dart
// المسار: features/profile/domain/entities/profile.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. جزء من ميزة الملف الشخصي.
//
// ماذا بداخله؟
//   • Profile
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// كلاس الملف الشخصي.
class Profile extends Equatable {
  /// دالة الملف الشخصي.
  const Profile({
    required this.uid,
    required this.username,
    required this.phone,
    required this.email,
  });

  /// حقل: uid.
  final String uid;
  /// حقل: username.
  final String username;
  /// حقل: phone.
  final String phone;
  /// حقل: البريد.
  final String email;

  @override
  /// يُرجع props.
  List<Object> get props => [uid, username, phone, email];
}
