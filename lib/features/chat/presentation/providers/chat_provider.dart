import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/data/chat_service.dart';
import 'package:messaging_app/features/contacts/domain/contact_model.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final _chatService = ChatService();
  Box<MessageModel>? _messageBox;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _messageBox = Hive.box<MessageModel>('messages');
    _isInitialized = true;
    notifyListeners();
  }

  List<MessageModel> getMessages(String contactId, String myId) {
    if (!_isInitialized || _messageBox == null) return [];
    final allMessages = _messageBox!.values.toList();
    final filtered = allMessages
        .where(
          (m) =>
              (m.senderId == myId && m.receiverId == contactId) ||
              (m.senderId == contactId && m.receiverId == myId),
        )
        .toList();
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    if (!_isInitialized || _messageBox == null) return;

    final message = MessageModel(
      id: _uuid.v4(),
      senderId: senderId,
      receiverId: receiverId,
      text: text.trim(),
      timestamp: DateTime.now().toUtc(),
    );

    await _messageBox!.put(message.id, message);
    notifyListeners();

    await _chatService.sendMessage(message);
  }

  void listenToChat(String myId, String contactId) {
    if (!_isInitialized) return;

    _chatService.listenToMessages(myId, contactId).listen((
      remoteMessages,
    ) async {
      for (final msg in remoteMessages) {
        await _messageBox!.put(msg.id, msg);
      }
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> getRecentChats(String myId) {
    if (!_isInitialized || _messageBox == null) return [];

    final allMessages = _messageBox!.values.toList();
    final contactsBox = Hive.box<ContactModel>('contacts'); // Obtener contactos

    final Map<String, List<MessageModel>> grouped = {};
    for (var msg in allMessages) {
      final contactId = msg.senderId == myId ? msg.receiverId : msg.senderId;
      grouped.putIfAbsent(contactId, () => []).add(msg);
    }

    final recentChats = grouped.entries.map((e) {
      e.value.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final contact = contactsBox.get(e.key); // Trae ContactModel
      return {
        'contact': contact, // ahora guardamos ContactModel
        'contactId': e.key,
        'lastMessage': e.value.first,
        'allMessages': e.value,
      };
    }).toList();

    recentChats.sort(
      (a, b) => (b['lastMessage'] as MessageModel).timestamp.compareTo(
        (a['lastMessage'] as MessageModel).timestamp,
      ),
    );

    return recentChats;
  }

  void listenToAllChats(String myId) {
    if (!_isInitialized) return;

    _chatService.listenToAllMessages(myId).listen((remoteMessages) async {
      for (final msg in remoteMessages) {
        await _messageBox!.put(msg.id, msg);
      }
      notifyListeners();
    });
  }
}
