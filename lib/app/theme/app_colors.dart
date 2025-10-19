import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color lightBlueBackground;
  final Color gradientStart;
  final Color gradientEnd;
  final Color avatarPurple;
  final Color avatarYellow;
  final Color avatarBlue;
  final Color avatarPink;

  const AppColors({
    required this.lightBlueBackground,
    required this.gradientStart,
    required this.gradientEnd,
    required this.avatarPurple,
    required this.avatarYellow,
    required this.avatarBlue,
    required this.avatarPink,
  });

  @override
  AppColors copyWith({
    Color? lightBlueBackground,
    Color? gradientStart,
    Color? gradientEnd,
    Color? avatarPurple,
    Color? avatarYellow,
    Color? avatarBlue,
    Color? avatarPink,
  }) {
    return AppColors(
      lightBlueBackground: lightBlueBackground ?? this.lightBlueBackground,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      avatarPurple: avatarPurple ?? this.avatarPurple,
      avatarYellow: avatarYellow ?? this.avatarYellow,
      avatarBlue: avatarBlue ?? this.avatarBlue,
      avatarPink: avatarPink ?? this.avatarPink,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      lightBlueBackground: Color.lerp(
        lightBlueBackground,
        other.lightBlueBackground,
        t,
      )!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
      avatarPurple: Color.lerp(avatarPurple, other.avatarPurple, t)!,
      avatarYellow: Color.lerp(avatarYellow, other.avatarYellow, t)!,
      avatarBlue: Color.lerp(avatarBlue, other.avatarBlue, t)!,
      avatarPink: Color.lerp(avatarPink, other.avatarPink, t)!,
    );
  }
}
