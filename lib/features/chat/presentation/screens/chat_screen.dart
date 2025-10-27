import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    Future.microtask(() async {
      await chatProvider.initialize();
      chatProvider.listenToChat(myId, widget.contactId);
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    if (!chatProvider.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final messages = chatProvider.getMessages(widget.contactId, myId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.gradientStart,
            context.colors.lightBlueBackground,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
          title: Text(widget.contactName),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.goNamed(AppRoutes.home),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return MessageBubble(message: message, myId: myId);
                },
              ),
            ),
            _ChatInputArea(
              controller: _controller,
              onSend: (text) async {
                if (text.trim().isEmpty) return;
                await chatProvider.sendMessage(
                  senderId: myId,
                  receiverId: widget.contactId,
                  text: text,
                );
                _controller.clear();
                _scrollToBottom();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String myId;

  const MessageBubble({super.key, required this.message, required this.myId});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.senderId == myId;
    final localTimestamp = message.timestamp.toLocal();
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final color = isMe
        ? Theme.of(context).colorScheme.secondary
        : context.colors.surface;
    final textColor = isMe ? Colors.black : null;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isMe ? 12 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 12),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(message.text, style: TextStyle(color: textColor)),
          ),
          const SizedBox(height: 2),
          Text(
            '${localTimestamp.hour}:${localTimestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;

  const _ChatInputArea({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                filled: true,
              ),
              onSubmitted: onSend,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => onSend(controller.text),
          ),
        ],
      ),
    );
  }
}
