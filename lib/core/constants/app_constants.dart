/// App-wide constants. Admin email used only for routing (admin dashboard).
class AppConstants {
  AppConstants._();

  /// Email that identifies the admin user. Used to route to admin dashboard.
  /// Do not store passwords in code.
  static const String adminEmail = 'admainaws@admainq.com';

  static bool isAdminEmail(String? email) {
    if (email == null) return false;
    return email.trim().toLowerCase() == adminEmail.toLowerCase();
  }
}
