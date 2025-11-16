import 'package:flutter/material.dart';
import '../widgets/contact_saved_dialog.dart';

class ContactsDialogService {
  static Future<bool> showContactSavedDialog(BuildContext context) async {
    final response = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ContactSavedDialog(),
    );

    return response ?? false;
  }
}
