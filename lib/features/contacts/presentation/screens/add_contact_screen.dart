import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/features/contacts/domain/validators/contact_validator.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:messaging_app/features/contacts/presentation/services/contacts_dialog_service.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Contacto")),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              validator: ContactValidator.nameValidate,
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: "+52",
              items: const [
                DropdownMenuItem(value: "+52", child: Text("México")),
              ],
              onChanged: null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(hintText: "+52"),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    validator: ContactValidator.phoneValidate,
                    decoration: const InputDecoration(
                      labelText: "Número de teléfono",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _onSave,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = "+52${_phoneController.text.trim()}";
    setState(() => _saving = true);
    final provider = context.read<ContactsProvider>();
    final result = await provider.createNewContact(name: name, phone: phone);
    setState(() => _saving = false);

    if (result.existsInApp) {
      _showUserExistsMessage();
      return;
    }

    final shouldClose = await ContactsDialogService.showContactSavedDialog(
      context,
    );

    if (shouldClose) {
      context.pop();
    } else {
      context.pop();
      context.pop();
    }
  }

  void _showUserExistsMessage() {
    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contacto agregado correctamente")),
    );
  }
}
