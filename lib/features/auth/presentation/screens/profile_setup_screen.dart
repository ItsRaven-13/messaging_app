import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/domain/validators/profile_validator.dart';
import 'package:messaging_app/features/auth/presentation/widgets/avatar_color_picker.dart';
import 'package:messaging_app/features/auth/presentation/widgets/avatar_preview.dart';
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
  final TextEditingController _infoController = TextEditingController();
  int _selectedColorIndex = 0;

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
    final avatarColors = AvatarColors(context).colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Configura tu perfil')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                AvatarPreview(
                  initials: _initials,
                  backgroundColor: avatarColors[_selectedColorIndex],
                ),
                const SizedBox(height: 30),
                AvatarColorPicker(
                  colors: avatarColors,
                  selectedIndex: _selectedColorIndex,
                  onColorSelected: (index) {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ProfileValidator.validate,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _infoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ProfileValidator.validateInfo,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.info),
                    labelText: 'Info.',
                    border: OutlineInputBorder(),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final name = _nameController.text.trim();
                    final info = _infoController.text.trim();

                    await auth.saveUserProfile(
                      name: name,
                      info: info,
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
      ),
    );
  }
}
