import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';

const String defaultFontFamily = 'Inter';
final ColorScheme lightColorScheme = ColorScheme.light(
  primary: AppColorsLight.primary,
  secondary: AppColorsLight.secondary,
  surface: AppColorsLight.background,
  error: Colors.redAccent,
  onPrimary: AppColorsLight.textPrimary,
  onSecondary: AppColorsLight.textSecondary,
  onSurface: AppColorsLight.textPrimary,
  onError: Colors.white,
  brightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColorsLight.primary,
  hintColor: AppColorsLight.secondary,
  scaffoldBackgroundColor: AppColorsLight.background,
  cardColor: AppColorsLight.surface,
  canvasColor: Colors.transparent,
  dividerColor: AppColorsLight.primary.withValues(alpha: 0.5),

  colorScheme: lightColorScheme,

  fontFamily: defaultFontFamily,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: AppColorsLight.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      color: AppColorsLight.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColorsLight.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.textPrimary,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: AppColorsLight.textPrimary),
    bodyMedium: TextStyle(fontSize: 14.0, color: AppColorsLight.textPrimary),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: AppColorsLight.textPrimary.withValues(alpha: 0.7),
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.surface,
    ),
    labelSmall: TextStyle(
      fontSize: 10.0,
      color: AppColorsLight.textPrimary.withValues(alpha: 0.6),
    ),
  ),
  useMaterial3: true,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColorsLight.primary,
    foregroundColor: AppColorsLight.textPrimary,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColorsLight.textPrimary,
    ),
    toolbarTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 18,
      color: AppColorsLight.textPrimary,
    ),
    centerTitle: true,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColorsLight.secondary,
    foregroundColor: AppColorsLight.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColorsLight.secondary,
      foregroundColor: AppColorsLight.surface,
      textStyle: TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColorsLight.primary,
      textStyle: TextStyle(fontFamily: defaultFontFamily, fontSize: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColorsLight.primary,
      side: BorderSide(
        color: AppColorsLight.textPrimary.withValues(alpha: 0.5),
      ),
      textStyle: TextStyle(fontFamily: defaultFontFamily, fontSize: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsLight.surface,
    hintStyle: TextStyle(
      color: AppColorsLight.textPrimary.withValues(alpha: 0.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColorsLight.secondary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    labelStyle: TextStyle(color: AppColorsLight.textPrimary),
    errorStyle: TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
  ),

  cardTheme: CardThemeData(
    color: AppColorsLight.surface,
    elevation: 0,
    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  ),

  iconTheme: IconThemeData(color: AppColorsLight.textPrimary, size: 24.0),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsLight.surface,
    selectedItemColor: AppColorsLight.secondary,
    unselectedItemColor: AppColorsLight.textPrimary.withValues(alpha: 0.5),
    selectedLabelStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 12.0,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 12.0,
    ),
    elevation: 5,
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColorsLight.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    titleTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: AppColorsLight.textPrimary,
    ),
    contentTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 16.0,
      color: AppColorsLight.textPrimary,
    ),
  ),
);
