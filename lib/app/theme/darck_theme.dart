import 'package:flutter/material.dart';

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(47, 133, 122, 1),
  brightness: Brightness.dark,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
);
