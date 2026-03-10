import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary - Deep Purple
  static const primary = Color(0xFF6B2FA0);
  static const primaryLight = Color(0xFF9B59C7);
  static const primaryDark = Color(0xFF4A1D73);
  static const primarySurface = Color(0xFFF5F0FA);

  // Secondary - Mint Green
  static const secondary = Color(0xFF4ECDC4);
  static const secondaryLight = Color(0xFF7EDDD6);
  static const secondaryDark = Color(0xFF36A89F);

  // Neutrals
  static const background = Color(0xFFFAF8FC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);

  // Semantic
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF3B82F6);

  // Progress
  static const progressTrack = Color(0xFFE8D5F5);
  static const progressFill = secondary;

  // Locked
  static const locked = Color(0xFFD1D5DB);
}
