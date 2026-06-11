// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: privacy_policy_state.dart
// المسار: features/profile/presentation/cubit/privacy_policy_state.dart
// الطبقة: presentation / cubit — منطق الواجهة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. شكل بيانات الحالة للواجهة.
//
// ماذا بداخله؟
//   • privacy_policy_state
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'package:equatable/equatable.dart';

sealed class PrivacyPolicyState extends Equatable {
  /// دالة الخصوصية السياسة الحالة.
  const PrivacyPolicyState();

  @override
  /// يُرجع props.
  List<Object?> get props => [];
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {
  /// دالة الخصوصية السياسة initial.
  const PrivacyPolicyInitial();
}

final class PrivacyPolicyLoading extends PrivacyPolicyState {
  /// دالة الخصوصية السياسة تحميل.
  const PrivacyPolicyLoading();
}

final class PrivacyPolicyLoaded extends PrivacyPolicyState {
  /// دالة الخصوصية السياسة loaded.
  const PrivacyPolicyLoaded(this.content);

  /// حقل: content.
  final String content;

  @override
  /// يُرجع props.
  List<Object?> get props => [content];
}

final class PrivacyPolicySaving extends PrivacyPolicyState {
  /// دالة الخصوصية السياسة saving.
  const PrivacyPolicySaving(this.content);

  /// حقل: content.
  final String content;

  @override
  /// يُرجع props.
  List<Object?> get props => [content];
}

final class PrivacyPolicyFailure extends PrivacyPolicyState {
  /// دالة الخصوصية السياسة فشل.
  const PrivacyPolicyFailure(this.message);

  /// حقل: message.
  final String message;

  @override
  /// يُرجع props.
  List<Object?> get props => [message];
}
