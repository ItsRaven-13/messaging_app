import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';

// Definición simple de un Grupo para simular datos
class Group {
  final String id;
  final String name;
  final String lastActivity;
  final Color avatarColor;
  final IconData icon;

  Group({
    required this.id,
    required this.name,
    required this.lastActivity,
    required this.avatarColor,
    this.icon = Icons.people,
  });
}

// Datos de prueba para la lista de grupos
List<Group> mockGroups = [
  Group(
    id: 'g1',
    name: 'Grupo Familia',
    lastActivity: '3 miembros',
    avatarColor: AppColors.avatarYellow,
  ),
  Group(
    id: 'g2',
    name: 'Amigos de la Uni',
    lastActivity: '2 miembros',
    avatarColor: AppColors.avatarBlue,
    icon: Icons.school,
  ),
  Group(
    id: 'g3',
    name: 'Trabajo - Proyectos',
    lastActivity: '7 miembros',
    avatarColor: AppColors.avatarPink,
    icon: Icons.work,
  ),
];

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Degradado para el AppBar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Grupos',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: AppColors.lightBlueBackground,
        child: ListView.builder(
          itemCount: mockGroups.length,
          itemBuilder: (context, index) {
            final group = mockGroups[index];
            return GroupListItem(group: group);
          },
        ),
      ),
    );
  }
}

// Widget para cada elemento de la lista de grupos
class GroupListItem extends StatelessWidget {
  final Group group;
  const GroupListItem({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar (Icono de grupo)
            CircleAvatar(
              radius: 25,
              backgroundColor: group.avatarColor,
              child: Icon(group.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            // Nombre y última actividad
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    group.lastActivity,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Íconos de acción (Configuración y Eliminar)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: () {
                // Lógica de configuración
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Lógica para eliminar grupo
              },
            ),
          ],
        ),
      ),
    );
  }
}
