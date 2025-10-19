import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/color_schemes.dart';
import 'package:messaging_app/app/theme/app_colors.dart';

const String defaultFontFamily = 'Inter';

class ThemeFactory {
  static ThemeData createTheme(AppColorPalette palette, {bool isDark = false}) {
    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: palette.primary,
            secondary: palette.secondary,
            surface: palette.background,
            error: Colors.redAccent,
            onPrimary: palette.textPrimary,
            onSecondary: palette.textSecondary,
            onSurface: palette.textPrimary,
            onError: Colors.white,
            brightness: Brightness.dark,
          )
        : ColorScheme.light(
            primary: palette.primary,
            secondary: palette.secondary,
            surface: palette.background,
            error: Colors.redAccent,
            onPrimary: palette.textPrimary,
            onSecondary: palette.textSecondary,
            onSurface: palette.textPrimary,
            onError: Colors.white,
            brightness: Brightness.light,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      primaryColor: palette.primary,
      hintColor: palette.secondary,
      scaffoldBackgroundColor: palette.background,
      cardColor: palette.surface,
      fontFamily: defaultFontFamily,
      dividerColor: palette.primary.withValues(alpha: 0.5),
      canvasColor: Colors.transparent,

      extensions: [
        AppColors(
          gradientStart: palette.gradientStart,
          gradientEnd: palette.gradientEnd,
          lightBlueBackground: palette.lightBlueBackground,
          avatarPurple: palette.avatarPurple,
          avatarYellow: palette.avatarYellow,
          avatarBlue: palette.avatarBlue,
          avatarPink: palette.avatarPink,
        ),
      ],

      textTheme: _buildTextTheme(palette),
      appBarTheme: _buildAppBarTheme(palette),
      inputDecorationTheme: _buildInputTheme(palette),
      elevatedButtonTheme: _buildElevatedButtonThemeData(palette),
      textButtonTheme: _buildTextButtonThemeData(palette),
      outlinedButtonTheme: _buildOutlinedButtonThemeData(palette),
      cardTheme: _buildCardTheme(palette),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(palette),
      dialogTheme: _buildDialogThemeData(palette),
      iconTheme: IconThemeData(color: palette.textPrimary, size: 24.0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.secondary,
        foregroundColor: palette.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(AppColorPalette palette) => TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: palette.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: palette.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: palette.textPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: palette.textPrimary,
    ),
    bodyLarge: TextStyle(fontSize: 16.0, color: palette.textPrimary),
    bodyMedium: TextStyle(fontSize: 14.0, color: palette.textPrimary),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: palette.textPrimary.withValues(alpha: 0.7),
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: palette.surface,
    ),
    labelSmall: TextStyle(
      fontSize: 10.0,
      color: palette.textPrimary.withValues(alpha: 0.6),
    ),
  );

  static AppBarTheme _buildAppBarTheme(AppColorPalette palette) => AppBarTheme(
    backgroundColor: palette.primary,
    foregroundColor: palette.textPrimary,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    toolbarTextStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 18,
      color: palette.textPrimary,
    ),
    centerTitle: true,
  );

  static InputDecorationTheme _buildInputTheme(AppColorPalette palette) =>
      InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        hintStyle: TextStyle(color: palette.textPrimary.withValues(alpha: 0.5)),
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
          borderSide: BorderSide(color: palette.secondary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        labelStyle: TextStyle(color: palette.textPrimary),
        errorStyle: TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
      );

  static ElevatedButtonThemeData _buildElevatedButtonThemeData(
    AppColorPalette palette,
  ) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: palette.secondary,
      foregroundColor: palette.surface,
      textStyle: TextStyle(
        fontFamily: defaultFontFamily,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
    ),
  );

  static TextButtonThemeData _buildTextButtonThemeData(
    AppColorPalette palette,
  ) => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: palette.primary,
      textStyle: TextStyle(fontFamily: defaultFontFamily, fontSize: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );

  static OutlinedButtonThemeData _buildOutlinedButtonThemeData(
    AppColorPalette palette,
  ) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: palette.primary,
      side: BorderSide(color: palette.textPrimary.withValues(alpha: 0.5)),
      textStyle: TextStyle(fontFamily: defaultFontFamily, fontSize: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );

  static CardThemeData _buildCardTheme(AppColorPalette palette) =>
      CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      );

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    AppColorPalette palette,
  ) => BottomNavigationBarThemeData(
    backgroundColor: palette.surface,
    selectedItemColor: palette.secondary,
    unselectedItemColor: palette.textPrimary.withValues(alpha: 0.5),
    selectedLabelStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 12.0,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: defaultFontFamily,
      fontSize: 12.0,
    ),
    elevation: 5,
  );

  static DialogThemeData _buildDialogThemeData(AppColorPalette palette) =>
      DialogThemeData(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        titleTextStyle: TextStyle(
          fontFamily: defaultFontFamily,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: palette.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: defaultFontFamily,
          fontSize: 16.0,
          color: palette.textPrimary,
        ),
      );
}
