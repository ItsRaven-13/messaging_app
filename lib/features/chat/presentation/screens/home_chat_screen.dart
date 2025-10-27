import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/constants/avatar_colors.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/domain/contact_model.dart';
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
      chatProvider.listenToAllChats(myId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';
    final recentChats = chatProvider.getRecentChats(myId);
    final avatarColors = AvatarColors(context).colors;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
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
      body: recentChats.isEmpty
          ? const Center(child: Text('No hay mensajes aún'))
          : ListView.builder(
              itemCount: recentChats.length,
              itemBuilder: (_, index) {
                final chat = recentChats[index];
                final MessageModel lastMsg = chat['lastMessage'];
                final ContactModel? contact = chat['contact'] as ContactModel?;
                final contactId = chat['contactId'];
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
                    context.pushNamed(AppRoutes.chat, extra: contact);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRoutes.contacts);
        },
        child: const Icon(Icons.message_rounded),
      ),
    );
  }
}
