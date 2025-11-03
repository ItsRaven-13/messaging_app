import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
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
      backgroundColor: Theme.of(context).cardColor,
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
              if (value == 'logout') {
                await auth.signOut();
                context.goNamed(AppRoutes.welcome);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group_add),
                    SizedBox(width: 8),
                    Text('New Group'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
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
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: avatarColors[contactColorIndex],
                          child: Text(initials),
                        ),
                        title: Text(contactName),
                        subtitle: Text(lastMsg.text),
                        trailing: Text(
                          '${localTimestamp.hour}:${localTimestamp.minute.toString().padLeft(2, '0')}',
                        ),
                        onTap: () {
                          final dataToPass =
                              contact ??
                              {
                                'contactId': contactId,
                                'contactName': contactName,
                              };
                          context.pushNamed(AppRoutes.chat, extra: dataToPass);
                        },
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
