import 'package:flutter/material.dart';
import 'package:messaging_app/app/app.dart';
import 'package:messaging_app/core/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

// Asegúrate de tener esta pantalla creada

void main(List<String> args) {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
