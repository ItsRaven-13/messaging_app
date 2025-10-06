import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';
import 'main_chat_screen.dart'; // Importa la pantalla principal

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsLight.background,
      appBar: AppBar(
        title: const Text(
          'Verificación',
          style: TextStyle(color: AppColorsLight.textPrimary),
        ),
        backgroundColor: AppColorsLight.primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texto de instrucción
              const Text(
                'Hemos enviado un código de verificación a tu número de teléfono.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColorsLight.textPrimary,
                ),
              ),

              const SizedBox(height: 20),

              // Campo de texto para el código de verificación
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.vpn_key),
                  hintText: 'Código de verificacion',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Botón "Ingresar"
              ElevatedButton(
                onPressed: () {
                  // Navega a la pantalla principal de chats
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainChatScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLight.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColorsLight.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Texto "No recibiste el código?"
              const Text(
                'No recibiste el codigo?',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColorsLight.textPrimary),
              ),

              // Botón "Reenviar SMS"
              TextButton(
                onPressed: () {
                  // Lógica para reenviar SMS
                },
                child: const Text(
                  'Reenviar SMS',
                  style: TextStyle(color: AppColorsLight.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
