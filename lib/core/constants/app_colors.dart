// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Paleta de colores para el tema claro
class AppColorsLight {
  // Colores base
  static const Color primary = Color(0xFFCFE7ED); // Azul claro (header)
  static const Color secondary = Color(0xFFF5CCE5); // Rosa claro (botones)
  static const Color background = Color(0xFFFFF7CE); // Beige (fondo general)
  static const Color surface = Colors.white; // Superficies (tarjetas, inputs)

  // Texto
  static const Color textPrimary = Colors.black; // Texto principal
  static const Color textSecondary = Colors.black54; // Texto secundario

  // Fondos y degradados
  static const Color lightBlueBackground = Color(0xFFE0F7FA); // Azul muy claro
  static const Color gradientStart = Color(0xFFCFE7ED); // Azul claro (inicio)
  static const Color gradientEnd = Color(0xFFFFF7CE); // Beige (fin)

  // Avatares
  static const Color avatarPurple = Color(0xFFD1C4E9); // Lila (K, J)
  static const Color avatarYellow = Color(0xFFFFF9C4); // Amarillo (Familia)
  static const Color avatarBlue = Color(0xFFB3E5FC); // Azul (L)
  static const Color avatarPink = Color(0xFFF8BBD0); // Rosa (F)
}

/// Paleta de colores para el tema oscuro
class AppColorsDark {
  // Colores base
  static const Color primary = Color(0xFF81D4FA); // Azul suave
  static const Color secondary = Color(0xFFE1BEE7); // Lila pastel
  static const Color background = Color(0xFF121212); // Fondo base oscuro
  static const Color surface = Color(0xFF1E1E1E); // Tarjetas y paneles
  static const Color surfaceContainer = Color(0xFF2C2C2C); // Inputs, campos

  // Texto
  static const Color textPrimary = Colors.white70;
  static const Color textSecondary = Colors.white54;

  // Gradientes suaves
  static const Color lightBlueBackground = Color(
    0xFF263238,
  ); // Azul grisáceo oscuro
  static const Color gradientStart = Color(0xFF2C3E50); // Azul grisáceo oscuro
  static const Color gradientEnd = Color(0xFF34495E); // Azul noche suave

  // Avatares adaptados
  static const Color avatarPurple = Color(0xFFB39DDB); // Lila más oscuro
  static const Color avatarYellow = Color(0xFFFFE082); // Amarillo tenue
  static const Color avatarBlue = Color(0xFF4FC3F7); // Azul claro legible
  static const Color avatarPink = Color(0xFFF48FB1); // Rosa pastel intenso
}
