import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/domain/validators/profile_validator.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/features/auth/presentation/widgets/avatar_color_picker.dart';
import 'package:messaging_app/features/auth/presentation/widgets/avatar_preview.dart';
import 'package:messaging_app/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController infoController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    infoController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    infoController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProfileProvider>(
      create: (context) =>
          UserProfileProvider(context.read<AuthProvider>())..loadUser(),
      child: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          if (provider.loading || provider.user == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (nameController.text.isEmpty) {
            nameController.text = provider.editedName;
            infoController.text = provider.editedInfo;
            phoneController.text = provider.user!.phoneNumber;
          }

          return Scaffold(
            appBar: AppBar(title: const Text("Mi Perfil")),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AvatarPreview(
                        initials: _initials(nameController.text),
                        backgroundColor: AvatarColors(
                          context,
                        ).colors[provider.selectedColorIndex],
                      ),
                      const SizedBox(height: 30),
                      AvatarColorPicker(
                        colors: AvatarColors(context).colors,
                        selectedIndex: provider.selectedColorIndex,
                        onColorSelected: provider.updateColorIndex,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        validator: ProfileValidator.validate,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Nombre",
                          suffixIcon: Icon(Icons.edit),
                          counterText: '',
                        ),
                        onChanged: provider.updateName,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: infoController,
                        validator: ProfileValidator.validateInfo,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.info),
                          labelText: "Info.",
                          suffixIcon: Icon(Icons.edit),
                          counterText: '',
                        ),
                        onChanged: provider.updateInfo,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        readOnly: true,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: "Número de Teléfono",
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          await provider.saveChanges();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Perfil actualizado")),
                          );
                          context.pop();
                        },
                        child: const Text("Guardar Cambios"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return "";
    final parts = trimmed.split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
