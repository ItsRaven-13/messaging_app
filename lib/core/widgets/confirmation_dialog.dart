import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = 'Aceptar',
  String cancelText = 'Cancelar',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Text(title, textAlign: TextAlign.center),
        ),
        content: Text(content, textAlign: TextAlign.center),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmText),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
  return result ?? false;
}
