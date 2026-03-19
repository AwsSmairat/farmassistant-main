import 'package:equatable/equatable.dart';

/// User profile for the profile screen (uid + display data).
class Profile extends Equatable {
  const Profile({
    required this.uid,
    required this.username,
    required this.phone,
    required this.email,
  });

  final String uid;
  final String username;
  final String phone;
  final String email;

  @override
  List<Object> get props => [uid, username, phone, email];
}
