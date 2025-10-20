import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/features/auth/domain/validators/profile_validator.dart';
import 'package:provider/provider.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  int _selectedColorIndex = 0;

  List<Color> _avatarColors(BuildContext context) => [
    context.colors.avatarBlue,
    context.colors.avatarPink,
    context.colors.avatarYellow,
    context.colors.avatarPurple,
  ];

  String get _initials {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu perfil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 45,
                backgroundColor: _avatarColors(context)[_selectedColorIndex],
                child: _initials.isNotEmpty
                    ? Text(_initials, style: const TextStyle(fontSize: 30))
                    : const Icon(Icons.add_a_photo_outlined, size: 40),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 16,
                children: List.generate(_avatarColors(context).length, (index) {
                  final color = _avatarColors(context)[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorIndex = index),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColorIndex == index
                              ? Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3)
                              : Colors.white,
                          width: 1.5, // grosor del borde
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: color,
                        child: _selectedColorIndex == index
                            ? Icon(
                                Icons.check,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.3),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                validator: ProfileValidator.validate,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final name = _nameController.text.trim();

                  await auth.saveUserProfile(
                    name: name,
                    colorIndex: _selectedColorIndex,
                  );

                  if (context.mounted) {
                    context.goNamed(AppRoutes.home);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Guardar y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
