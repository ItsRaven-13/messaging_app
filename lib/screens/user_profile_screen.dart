import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorsLight.gradientStart,
                AppColorsLight.gradientEnd,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            color: AppColorsLight.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColorsLight.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: AppColorsLight.lightBlueBackground,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // Avatar grande
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: AppColorsLight.avatarPurple,
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Botón para editar la imagen (no en el mockup, pero útil)
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Cambiar foto de perfil',
                    style: TextStyle(color: AppColorsLight.primary),
                  ),
                ),
                const SizedBox(height: 30),

                // Tarjeta de información del perfil (simulando los campos de texto)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _ProfileField(
                          label: 'Nombre completo',
                          value: 'Juan Pérez', // Simulado
                          icon: Icons.person_outline,
                        ),
                        const Divider(),
                        _ProfileField(
                          label: 'Estado',
                          value: 'Disponible para chatear', // Simulado
                          icon: Icons.info_outline,
                        ),
                        const Divider(),
                        _ProfileField(
                          label: 'Número de teléfono',
                          value: '+52 55 1234 5678', // Simulado
                          icon: Icons.phone_android,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón para editar (se podría usar el botón rosa)
                ElevatedButton(
                  onPressed: () {
                    // Lógica para guardar o editar el perfil
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsLight.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColorsLight.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para mostrar un campo de perfil
class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColorsLight.primary),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColorsLight.textPrimary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // Lógica para editar este campo
          },
        ),
      ],
    );
  }
}
