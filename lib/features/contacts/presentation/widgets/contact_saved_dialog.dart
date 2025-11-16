import 'package:flutter/material.dart';

class ContactSavedDialog extends StatelessWidget {
  const ContactSavedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const Text("Contacto registrado", textAlign: TextAlign.center),
      ),
      content: const Text(
        "El contacto se guardó correctamente, pero aún no usa nuestra aplicación.",
        textAlign: TextAlign.center,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("OK"),
            ),
          ),
        ),
      ],
    );
  }
}
