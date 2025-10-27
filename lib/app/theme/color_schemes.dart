import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';

class AppColorPalette {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color gradientStart;
  final Color gradientEnd;
  final Color lightBlueBackground;
  final Color avatarPurple;
  final Color avatarYellow;
  final Color avatarBlue;
  final Color avatarPink;

  const AppColorPalette({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.gradientStart,
    required this.gradientEnd,
    required this.lightBlueBackground,
    required this.avatarPurple,
    required this.avatarYellow,
    required this.avatarBlue,
    required this.avatarPink,
  });

  static const light = AppColorPalette(
    primary: AppColorsLight.primary,
    secondary: AppColorsLight.secondary,
    background: AppColorsLight.background,
    surface: AppColorsLight.surface,
    textPrimary: AppColorsLight.textPrimary,
    textSecondary: AppColorsLight.textSecondary,
    gradientStart: AppColorsLight.gradientStart,
    gradientEnd: AppColorsLight.gradientEnd,
    lightBlueBackground: AppColorsLight.lightBlueBackground,
    avatarPurple: AppColorsLight.avatarPurple,
    avatarYellow: AppColorsLight.avatarYellow,
    avatarBlue: AppColorsLight.avatarBlue,
    avatarPink: AppColorsLight.avatarPink,
  );

  static const dark = AppColorPalette(
    primary: AppColorsDark.primary,
    secondary: AppColorsDark.secondary,
    background: AppColorsDark.background,
    surface: AppColorsDark.surface,
    textPrimary: AppColorsDark.textPrimary,
    textSecondary: AppColorsDark.textSecondary,
    gradientStart: AppColorsDark.gradientStart,
    gradientEnd: AppColorsDark.gradientEnd,
    lightBlueBackground: AppColorsDark.lightBlueBackground,
    avatarPurple: AppColorsDark.avatarPurple,
    avatarYellow: AppColorsDark.avatarYellow,
    avatarBlue: AppColorsDark.avatarBlue,
    avatarPink: AppColorsDark.avatarPink,
  );
}
