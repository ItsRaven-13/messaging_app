import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart'; // Asegúrate de tener este archivo o los colores definidos

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Verificación',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  // Aquí iría la lógica para verificar el código y navegar a la pantalla principal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 18, color: AppColors.textColor),
                ),
              ),

              const SizedBox(height: 20),

              // Texto "No recibiste el código?"
              const Text(
                'No recibiste el codigo?',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textColor),
              ),

              // Botón "Reenviar SMS"
              TextButton(
                onPressed: () {
                  // Lógica para reenviar SMS
                },
                child: const Text(
                  'Reenviar SMS',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
