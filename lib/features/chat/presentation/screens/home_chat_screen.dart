import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:provider/provider.dart';

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  @override
  void initState() {
    super.initState();
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    Future.microtask(() async {
      await chatProvider.initialize(myId: myId);
      await chatProvider.getRecentChats(myId);
      chatProvider.listenToAllChats(myId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final contacts = context.watch<ContactsProvider>().contacts;

    final auth = context.read<AuthProvider>();
    final avatarColors = AvatarColors(context).colors;

    final recentChats = chatProvider.recentChats;

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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Mensajería'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'perfil') {
                context.pushNamed(AppRoutes.profileEdit);
              } else if (value == 'contactos') {
                context.pushNamed(AppRoutes.contacts);
              } else if (value == 'new_group') {
                // Lógica para crear un nuevo grupo
              } else if (value == 'logout') {
                await auth.signOut();
                context.goNamed(AppRoutes.welcome);
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'perfil',
                child: Text('Perfil'),
              ),
              const PopupMenuItem<String>(
                value: 'contactos',
                child: Text('Contactos'),
              ),
              const PopupMenuItem<String>(
                value: 'new_group',
                child: Text('Nuevo Grupo'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),
      body: !chatProvider.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : (recentChats.isEmpty
                ? const Center(child: Text('No hay mensajes aún'))
                : ListView.builder(
                    itemCount: recentChats.length,
                    itemBuilder: (_, index) {
                      final chat = recentChats[index];
                      final MessageModel lastMsg =
                          chat['lastMessage'] as MessageModel;
                      final ContactModel contact = contacts.firstWhere(
                        (c) => c.uid == chat['contactId'],
                        orElse: () => chat['contact'],
                      );
                      final contactName = contact.name;
                      final initials = contact.initials;
                      final contactColorIndex = contact.colorIndex;
                      final localTimestamp = lastMsg.timestamp.toLocal();
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: avatarColors[contactColorIndex],
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contactName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: _buildMessagePreview(lastMsg),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if ((chat['unreadCount'] ?? 0) > 0) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 24,
                                    minHeight: 24,
                                  ),
                                  child: Text(
                                    '${chat['unreadCount']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                '${localTimestamp.hour}:${localTimestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            final dataToPass = contact;
                            context.pushNamed(
                              AppRoutes.chat,
                              extra: dataToPass,
                            );
                          },
                        ),
                      );
                    },
                  )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRoutes.contacts);
        },
        child: const Icon(Icons.message_rounded),
      ),
    );
  }

  Widget _buildMessagePreview(MessageModel message) {
    if (message.hasImage) {
      return Row(
        children: [
          const Icon(Icons.photo, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            message.text.isNotEmpty ? message.text : 'Imagen',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      return Text(
        message.text,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }
}
