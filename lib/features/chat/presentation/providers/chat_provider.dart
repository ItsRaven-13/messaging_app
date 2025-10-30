import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:messaging_app/features/chat/data/chat_service.dart';
import 'package:messaging_app/features/contacts/domain/models/contact_model.dart';
import 'package:messaging_app/shared/services/user_service.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  final _chatService = ChatService();
  final _userService = UserService();
  Box<MessageModel>? _messageBox;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  List<Map<String, dynamic>> _recentChats = [];
  List<Map<String, dynamic>> get recentChats => _recentChats;

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
    await _chatService.sendMessage(message);

    await _recalculateRecentChats(senderId);
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

  Future<void> _recalculateRecentChats(String myId) async {
    if (!_isInitialized || _messageBox == null) return;

    final allMessages = _messageBox!.values.toList();
    final contactsBox = Hive.box<ContactModel>('contacts');

    final Map<String, List<MessageModel>> grouped = {};
    for (var msg in allMessages) {
      final contactId = msg.senderId == myId ? msg.receiverId : msg.senderId;
      grouped.putIfAbsent(contactId, () => []).add(msg);
    }

    final List<Future<Map<String, dynamic>>> recentChatsFutures = grouped
        .entries
        .map((e) async {
          e.value.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          ContactModel? contact = contactsBox.get(e.key);
          contact ??= await _userService.fetchUserAsContact(e.key);

          return {
            'contact': contact,
            'contactId': e.key,
            'lastMessage': e.value.first,
            'allMessages': e.value,
          };
        })
        .toList();

    final calculatedChats = await Future.wait(recentChatsFutures);

    recentChats.sort(
      (a, b) => (b['lastMessage'] as MessageModel).timestamp.compareTo(
        (a['lastMessage'] as MessageModel).timestamp,
      ),
    );
    _recentChats = calculatedChats;
    notifyListeners();
  }

  Future<void> getRecentChats(String myId) async {
    await _recalculateRecentChats(myId);
  }

  void listenToAllChats(String myId) {
    if (!_isInitialized) return;

    _chatService.listenToAllMessages(myId).listen((remoteMessages) async {
      await _messageBox!.putAll({
        for (final msg in remoteMessages) msg.id: msg,
      });

      await _recalculateRecentChats(myId);
    });
  }
}
