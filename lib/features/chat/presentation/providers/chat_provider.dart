import 'dart:async';

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
  StreamSubscription<List<MessageModel>>? _allChatsSubscription;
  final Map<String, StreamSubscription<List<MessageModel>>> _chatSubscriptions =
      {};
  final Set<String> _pendingReadMessages = {};
  Timer? _cleanupTimer;

  Future<void> initialize({String? myId}) async {
    if (_isInitialized) return;
    _messageBox = await Hive.openBox<MessageModel>('messages');
    _isInitialized = true;

    if (myId != null) {
      _processPendingReadMessages(myId);
    }
    _cleanupTimer = Timer.periodic(const Duration(hours: 1), (_) {
      cleanupPendingOperations();
    });

    notifyListeners();
  }

  Future<void> markMessagesAsRead(String myId, String contactId) async {
    if (!_isInitialized || _messageBox == null) return;

    final unreadMessages = _messageBox!.values
        .where(
          (msg) =>
              msg.receiverId == myId &&
              msg.senderId == contactId &&
              !msg.isRead,
        )
        .toList();

    final updates = <String, MessageModel>{};
    for (final msg in unreadMessages) {
      final updated = MessageModel(
        id: msg.id,
        senderId: msg.senderId,
        receiverId: msg.receiverId,
        text: msg.text,
        timestamp: msg.timestamp,
        isRead: true,
      );
      updates[msg.id] = updated;
      _pendingReadMessages.add(msg.id);
    }
    await _messageBox!.putAll(updates);
    notifyListeners();
    _syncReadMessagesWithFirebase(myId, contactId, unreadMessages);
  }

  Future<void> _syncReadMessagesWithFirebase(
    String myId,
    String contactId,
    List<MessageModel> messages,
  ) async {
    if (messages.isEmpty) return;

    try {
      await _chatService.markMessagesAsRead(myId, contactId);

      for (final msg in messages) {
        _pendingReadMessages.remove(msg.id);
      }
    } catch (e) {
      debugPrint('Error sincronizando mensajes leídos con Firebase: $e');
    }
  }

  Future<void> _processPendingReadMessages(String myId) async {
    if (_pendingReadMessages.isEmpty || _messageBox == null) return;

    try {
      final pendingMessages = _messageBox!.values
          .where((msg) => _pendingReadMessages.contains(msg.id))
          .toList();

      final messagesByContact = <String, List<MessageModel>>{};
      for (final msg in pendingMessages) {
        final contactId = msg.senderId;
        messagesByContact.putIfAbsent(contactId, () => []).add(msg);
      }

      for (final entry in messagesByContact.entries) {
        await _syncReadMessagesWithFirebase(myId, entry.key, entry.value);
      }
    } catch (e) {
      debugPrint('Error procesando mensajes leídos pendientes: $e');
    }
  }

  Future<void> syncPendingOperations(String myId) async {
    await _processPendingReadMessages(myId);
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

    _chatSubscriptions[contactId]?.cancel();

    _chatSubscriptions[contactId] = _chatService
        .listenToMessages(myId, contactId)
        .listen((remoteMessages) async {
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

    final List<Map<String, dynamic>> calculatedChats = [];

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      ContactModel? contact = contactsBox.get(entry.key);
      contact ??= await _userService.fetchUserAsContact(entry.key);

      final unreadCount = entry.value
          .where((msg) => msg.receiverId == myId && !msg.isRead)
          .length;

      calculatedChats.add({
        'contact': contact,
        'contactId': entry.key,
        'lastMessage': entry.value.first,
        'allMessages': entry.value,
        'unreadCount': unreadCount,
      });
    }

    calculatedChats.sort(
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

    _allChatsSubscription?.cancel();

    _allChatsSubscription = _chatService.listenToAllMessages(myId).listen((
      remoteMessages,
    ) async {
      await _messageBox!.putAll({
        for (final msg in remoteMessages) msg.id: msg,
      });

      await _recalculateRecentChats(myId);
    });
  }

  Future<void> cancelAllListeners() async {
    await _allChatsSubscription?.cancel();
    _allChatsSubscription = null;

    for (final sub in _chatSubscriptions.values) {
      await sub.cancel();
    }
    _chatSubscriptions.clear();
  }

  Future<void> cleanupPendingOperations() async {
    final now = DateTime.now();
    final messagesToRemove = <String>[];

    if (_messageBox == null) return;

    for (final messageId in _pendingReadMessages) {
      final message = _messageBox!.get(messageId);
      if (message != null) {
        if (now.difference(message.timestamp).inDays > 1) {
          messagesToRemove.add(messageId);
        }
      } else {
        messagesToRemove.add(messageId);
      }
    }

    for (final messageId in messagesToRemove) {
      _pendingReadMessages.remove(messageId);
    }
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    _allChatsSubscription?.cancel();
    for (final sub in _chatSubscriptions.values) {
      sub.cancel();
    }
    _chatSubscriptions.clear();
    super.dispose();
  }
}
