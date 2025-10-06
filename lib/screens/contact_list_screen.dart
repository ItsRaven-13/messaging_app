import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';

// Definición simple de un Contacto
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final Color avatarColor;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.avatarColor,
  });
}

// Datos de prueba
List<Contact> mockContacts = [
  Contact(
    id: 'c1',
    name: 'Ana Rodríguez',
    phoneNumber: '+52 1111',
    avatarColor: AppColorsLight.avatarPurple,
  ),
  Contact(
    id: 'c2',
    name: 'Carlos García',
    phoneNumber: '+52 2222',
    avatarColor: AppColorsLight.avatarBlue,
  ),
  Contact(
    id: 'c3',
    name: 'Elena Torres',
    phoneNumber: '+52 3333',
    avatarColor: AppColorsLight.avatarYellow,
  ),
  Contact(
    id: 'c4',
    name: 'Fernando Lima',
    phoneNumber: '+52 4444',
    avatarColor: AppColorsLight.avatarPink,
  ),
];

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

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
          'Contactos',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColorsLight.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: AppColorsLight.lightBlueBackground,
        child: ListView.builder(
          itemCount: mockContacts.length,
          itemBuilder: (context, index) {
            final contact = mockContacts[index];
            return ContactListItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para mostrar las opciones "Crear Grupo" o "Agregar Contacto"
          _showContactOptions(context);
        },
        backgroundColor: AppColorsLight.secondary,
        child: const Icon(Icons.add, color: AppColorsLight.textPrimary),
      ),
    );
  }
}

// Widget auxiliar para mostrar las opciones del FloatingActionButton
void _showContactOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.group_add,
                color: AppColorsLight.primary,
              ),
              title: const Text('Crear Grupo'),
              onTap: () {
                Navigator.pop(bc);
                // Navegar a la pantalla de creación de grupo
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person_add,
                color: AppColorsLight.primary,
              ),
              title: const Text('Agregar Contacto'),
              onTap: () {
                Navigator.pop(bc);
                // Navegar a la pantalla de agregar contacto
              },
            ),
          ],
        ),
      );
    },
  );
}

// Widget para cada elemento de la lista de contactos
class ContactListItem extends StatelessWidget {
  final Contact contact;
  const ContactListItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Al tocar un contacto, se podría iniciar un chat con él
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 25,
                backgroundColor: contact.avatarColor,
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Nombre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColorsLight.textPrimary,
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
