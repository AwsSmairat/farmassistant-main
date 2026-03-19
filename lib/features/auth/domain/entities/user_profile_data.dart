import 'package:equatable/equatable.dart';

/// Full profile data from user_profiles (username, phone, email).
class UserProfileData extends Equatable {
  const UserProfileData({
    required this.username,
    required this.phone,
    required this.email,
  });

  final String username;
  final String phone;
  final String email;

  @override
  List<Object> get props => [username, phone, email];
}
