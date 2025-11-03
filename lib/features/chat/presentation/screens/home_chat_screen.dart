import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/screens/user_profile_screen.dart';
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
      await chatProvider.initialize();
      await chatProvider.getRecentChats(myId);
      chatProvider.listenToAllChats(myId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ),
                );
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
                      final ContactModel? contact =
                          chat['contact'] as ContactModel?;
                      final String contactId = chat['contactId'] as String;
                      final contactName = contact?.name ?? contactId;
                      final initials = contact?.initials ?? '??';
                      final contactColorIndex = contact?.colorIndex ?? 0;
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
                          subtitle: Text(
                            lastMsg.text,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (1 > 0) ...[
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
                                    '10',
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
                            final dataToPass =
                                contact ??
                                {
                                  'contactId': contactId,
                                  'contactName': contactName,
                                };
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
}
