import 'package:cached_network_image/cached_network_image.dart';
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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    Future.microtask(() async {
      await chatProvider.initialize(myId: myId);
      chatProvider.listenToChat(myId, widget.contactId);
      chatProvider.markMessagesAsRead(myId, widget.contactId);
    });
  }

  Future<void> _sendImage() async {
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    try {
      await chatProvider.sendImageMessage(
        senderId: myId,
        receiverId: widget.contactId,
        caption: _controller.text.trim(),
      );
      _controller.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al enviar imagen: $e')));
      }
    }
  }

  void _checkForNewMessages(List<MessageModel> messages, String myId) {
    final newMessages = messages.where(
      (msg) => msg.receiverId == myId && !msg.isRead,
    );

    if (newMessages.isNotEmpty) {
      _onNewMessage();
    }
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

  void _onNewMessage() {
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<AuthProvider>();
    final myId = auth.user?.uid ?? 'myId';

    chatProvider.markMessagesAsRead(myId, widget.contactId);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForNewMessages(messages, myId);
      _scrollToBottom();
    });

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
            if (chatProvider.isUploadingImage)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: chatProvider.uploadProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Subiendo imagen...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
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
              focusNode: _focusNode,
              onSend: (text) async {
                if (text.trim().isEmpty) return;
                final chatProvider = context.read<ChatProvider>();
                final auth = context.read<AuthProvider>();
                final myId = auth.user?.uid ?? 'myId';
                await chatProvider.sendMessage(
                  senderId: myId,
                  receiverId: widget.contactId,
                  text: text,
                );
                _controller.clear();
                _scrollToBottom();
              },
              onSendImage: _sendImage,
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

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              boxShadow: message.hasImage
                  ? []
                  : [
                      BoxShadow(
                        color: color.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.hasImage)
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: GestureDetector(
                      onTap: () =>
                          _showImagePreview(context, message.imageUrl!),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: message.imageUrl!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, size: 40),
                                    SizedBox(height: 8),
                                    Text('Error al cargar imagen'),
                                  ],
                                ),
                              ),
                            ),
                            if (message.type == MessageType.image)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (message.text.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: message.hasImage ? 0 : 8,
                      bottom: 8,
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(color: textColor),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${localTimestamp.hour}:${localTimestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
          if (isMe)
            Icon(
              message.isRead ? Icons.done_all : Icons.done,
              size: 14,
              color: message.isRead ? Colors.blue : Colors.grey,
            ),
        ],
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSend;
  final VoidCallback onSendImage;

  const _ChatInputArea({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onSendImage,
  });

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
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: onSendImage,
            tooltip: 'Enviar imagen',
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
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
            tooltip: 'Enviar mensaje',
          ),
        ],
      ),
    );
  }
}
