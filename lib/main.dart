import 'package:flutter/material.dart';
import 'package:messaging_app/screens/login_screen.dart'; 
import 'package:messaging_app/screens/main_chat_screen.dart';

// Asegúrate de tener esta pantalla creada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Puedes definir un tema global aquí si lo necesitas
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}