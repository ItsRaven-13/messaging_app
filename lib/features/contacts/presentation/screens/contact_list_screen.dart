import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/core/widgets/search_app_bar_widget.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final contactsProvider = Provider.of<ContactsProvider>(
      context,
      listen: false,
    );
    if (authProvider.isLoggedIn && !contactsProvider.initialized) {
      final myId = authProvider.user!.uid;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        contactsProvider.initialize(myId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: context.colors.lightBlueBackground,
          appBar: SearchAppBar(
            titleText: 'Contactos',
            onBackButtonPressed: () => context.pop(),
            onSearchChanged: (query) {
              provider.setSearchQuery(query);
            },
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? Center(child: Text(provider.error!))
              : provider.contacts.isEmpty
              ? Center(
                  child: Text(
                    provider.searchQuery.isNotEmpty
                        ? "No se encontraron contactos para '${provider.searchQuery}'"
                        : "Aun no tienes contactos que usen la app",
                    textAlign: TextAlign.center,
                  ),
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
    builder: (BuildContext modalContext) {
      // Usamos modalContext para evitar confusión
      return Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Nuevo Contacto'),
              onTap: () {
                modalContext.pop();
                GoRouter.of(context).pushNamed(AppRoutes.addContact);
              },
            ),
          ],
        ),
      );
    },
  );
}
