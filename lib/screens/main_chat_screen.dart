import 'package:flutter/material.dart';
import 'package:messaging_app/theme/app_colors.dart';
import 'chat_screen.dart'; // Vamos a pre-importar la pantalla de chat
import 'group_list_screen.dart'; // Para el menú de grupos
import 'user_profile_screen.dart'; // Para el menú de perfil
import 'contact_list_screen.dart'; // Para el menú de contactos

// --- MODELOS DE DATOS SIMULADOS ---
// Estos modelos serán reemplazados por datos reales del backend más adelante.
class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isGroup;
  final Color avatarColor; // Para simular el color del avatar
  final IconData? groupIcon; // Para simular el icono de grupo

  Chat({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isGroup = false,
    required this.avatarColor,
    this.groupIcon,
  });
}

// Datos de prueba para la lista de chats
List<Chat> mockChats = [
  Chat(
    id: '1',
    name: 'Kevin López',
    lastMessage: 'Hola, zya estas?',
    lastMessageTime: '10:25 PM',
    unreadCount: 2,
    avatarColor: AppColors.avatarPurple,
  ),
  Chat(
    id: '2',
    name: 'Grupo Familia',
    lastMessage: 'Mama: Manda foto',
    lastMessageTime: '9:10 PM',
    isGroup: true,
    avatarColor: AppColors.avatarYellow,
    groupIcon: Icons.people,
  ),
  Chat(
    id: '3',
    name: 'Luis Mario',
    lastMessage: 'Sale, nos vemos',
    lastMessageTime: '8:05 PM',
    avatarColor: AppColors.avatarBlue,
  ),
  // Puedes agregar más chats de prueba aquí
];


// --- WIDGET DE LA PANTALLA PRINCIPAL ---
class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Degradado de color en el AppBar
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
          'Mensajería',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textColor),
            onPressed: () {
              // Lógica para buscar
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Lógica para las opciones del menú
              if (value == 'grupos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupListScreen()),
                );
              } else if (value == 'perfil') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                );
              } else if (value == 'contactos') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactListScreen()),
                );
              }
            },
            icon: const Icon(Icons.more_vert, color: AppColors.textColor),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'grupos',
                child: Text('Ver Grupos'),
              ),
              const PopupMenuItem<String>(
                value: 'perfil',
                child: Text('Mi Perfil'),
              ),
              const PopupMenuItem<String>(
                value: 'contactos',
                child: Text('Contactos'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: AppColors.lightBlueBackground, // Fondo de la pantalla principal
        child: ListView.builder(
          itemCount: mockChats.length,
          itemBuilder: (context, index) {
            final chat = mockChats[index];
            return ChatListItem(chat: chat);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para iniciar nueva conversación o crear grupo
          // Podrías mostrar un modal o navegar a una pantalla de selección
        },
        backgroundColor: AppColors.secondaryColor,
        child: const Icon(Icons.add, color: AppColors.textColor),
      ),
    );
  }
}

// Widget para cada elemento de la lista de chat
class ChatListItem extends StatelessWidget {
  final Chat chat;
  const ChatListItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0, // Elimina la sombra para un aspecto más plano
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white, // Fondo blanco de la tarjeta
      child: InkWell(
        onTap: () {
          // Navega a la pantalla de chat específica
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar (inicial o icono de grupo)
              CircleAvatar(
                radius: 25,
                backgroundColor: chat.avatarColor,
                child: chat.isGroup
                    ? Icon(chat.groupIcon, color: Colors.white, size: 28)
                    : Text(
                        chat.name[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
              ),
              const SizedBox(width: 16),
              // Nombre y último mensaje
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Hora y contador de no leídos
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    chat.lastMessageTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  if (chat.unreadCount > 0) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor, // Color rosa para el contador
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      child: Text(
                        '${chat.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}