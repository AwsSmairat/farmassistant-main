// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: user_profile_data.dart
// المسار: features/auth/domain/entities/user_profile_data.dart
// الطبقة: domain / entities — كيان
//
// ماذا يفعل؟
//   جزء من ميزة: المصادقة وتسجيل الدخول. جزء من ميزة المصادقة وتسجيل الدخول.
//
// ماذا بداخله؟
//   • UserProfileData
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';
/// كلاس المستخدم الملف الشخصي بيانات.
class UserProfileData extends Equatable {
  /// دالة المستخدم الملف الشخصي بيانات.
  const UserProfileData({
    required this.username,
    required this.phone,
    required this.email,
  });

  /// حقل: username.
  final String username;
  /// حقل: phone.
  final String phone;
  /// حقل: البريد.
  final String email;

  @override
  /// يُرجع props.
  List<Object> get props => [username, phone, email];
}
