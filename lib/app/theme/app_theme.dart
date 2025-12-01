import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/color_schemes.dart';
import 'package:messaging_app/app/theme/theme_factory.dart';

class AppTheme {
  static final ThemeData light = ThemeFactory.createTheme(
    AppColorPalette.light,
  );
  static final ThemeData dark = ThemeFactory.createTheme(
    AppColorPalette.dark,
    isDark: true,
  );
  static ThemeData get highContrastDark => ThemeFactory.createTheme(
    AppColorPalette.dark,
    isDark: true,
  ).copyWith(colorScheme: ColorScheme.highContrastDark());
}
