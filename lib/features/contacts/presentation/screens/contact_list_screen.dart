import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: context.colors.lightBlueBackground,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colors.gradientStart,
                    context.colors.gradientEnd,
                  ],
                ),
              ),
            ),
            title: const Text('Contactos'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? Center(child: Text(provider.error!))
              : provider.contacts.isEmpty
              ? const Center(
                  child: Text("Aun no tienes contactos que usen la app"),
                )
              : ListView.builder(
                  itemCount: provider.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = provider.contacts[index];
                    return _ContactListItem(contact: contact);
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showContactOptions(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _ContactListItem extends StatelessWidget {
  final ContactModel contact;
  const _ContactListItem({required this.contact});

  @override
  Widget build(BuildContext context) {
    final avatarColors = AvatarColors(context).colors;
    return Card(
      child: InkWell(
        onTap: () {
          context.goNamed(AppRoutes.chat, extra: contact);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: avatarColors[contact.colorIndex],
                child: Text(
                  contact.initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.phoneNumber,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showContactOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Nuevo Contacto'),
              onTap: () {
                context.pop(bc);
                context.pushNamed(AppRoutes.addContact);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Nuevo Grupo'),
              onTap: () {
                context.pop(bc);
                context.pushNamed(AppRoutes.createGroups);
              },
            ),
          ],
        ),
      );
    },
  );
}
