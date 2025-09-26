// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFCFE7ED); // Azul claro original (header)
  static const Color secondaryColor = Color(0xFFF5CCE5); // Rosa claro original (botones)
  static const Color backgroundColor = Color(0xFFFFF7CE); // Beige original (fondo general)

  static const Color textColor = Colors.black; // Negro para el texto

  // Nuevos colores de los mockups
  static const Color lightBlueBackground = Color(0xFFE0F7FA); // Un azul muy claro para fondos o degradados
  static const Color gradientStart = Color(0xFFCFE7ED); // Azul claro (similar a primaryColor)
  static const Color gradientEnd = Color(0xFFFFF7CE); // Beige (similar a backgroundColor)

  // Colores para avatares (puedes añadir más si quieres)
  static const Color avatarPurple = Color(0xFFD1C4E9); // Lila para "K", "J"
  static const Color avatarYellow = Color(0xFFFFF9C4); // Amarillo para "Grupo Familia"
  static const Color avatarBlue = Color(0xFFB3E5FC); // Azul para "L"
  static const Color avatarPink = Color(0xFFF8BBD0); // Rosa para "F"
} 