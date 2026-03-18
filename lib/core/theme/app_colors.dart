import 'package:flutter/material.dart';

/// Application color palette inspired by AgriPulse/AgriBot dark theme.
/// Use these colors across the app for consistency.
abstract final class AppColors {
  AppColors._();

  // --- Backgrounds ---
  /// Main screen background (deep dark brown/charcoal).
  static const Color background = Color(0xFF261A14);

  /// Slightly lighter background for cards, containers, input fields.
  static const Color surface = Color(0xFF3B2C21);

  /// Darker surface for secondary cards or inactive elements.
  static const Color surfaceVariant = Color(0xFF2A1E14);

  /// Input field / search bar background.
  static const Color inputBackground = Color(0xFF312117);

  // --- Primary / Accent ---
  /// Primary accent orange (brand, primary button, active states).
  static const Color primary = Color(0xFFF37A20);

  /// Slightly darker orange for hover/pressed or secondary accent.
  static const Color primaryDark = Color(0xFFE65100);

  /// Lighter orange for highlights or gradients.
  static const Color primaryLight = Color(0xFFFF9800);

  // --- Text ---
  /// Primary text (titles, main content).
  static const Color textPrimary = Color(0xFFEEEEEE);

  /// Secondary text (labels, descriptions, inactive).
  static const Color textSecondary = Color(0xFFA0A0A0);

  /// Muted text (placeholders, hints).
  static const Color textMuted = Color(0xFF808080);

  /// Text on primary (e.g. button label).
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Status ---
  /// Success / online / positive change.
  static const Color success = Color(0xFF4CAF50);

  /// Error / offline / negative change / alert.
  static const Color error = Color(0xFFE53935);

  /// Warning / maintenance.
  static const Color warning = Color(0xFFFF9800);

  /// Info / charging / link.
  static const Color info = Color(0xFF2196F3);

  /// Status tag: adequate (light blue/cyan).
  static const Color statusAdequate = Color(0xFF00BCD4);

  /// Status tag: balanced (terracotta).
  static const Color statusBalanced = Color(0xFFFF7043);

  /// Purple accent (e.g. pH, charts).
  static const Color accentPurple = Color(0xFF9C27B0);

  /// Blue accent (e.g. soil moisture).
  static const Color accentBlue = Color(0xFF2196F3);

  // --- UI elements ---
  /// Divider / border.
  static const Color border = Color(0xFF4A3F35);

  /// Progress bar track (unfilled).
  static const Color progressTrack = Color(0xFF3A2F24);

  /// Bottom nav / app bar background.
  static const Color navBackground = Color(0xFF1B140F);
}
