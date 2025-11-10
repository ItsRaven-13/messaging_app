import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    final chatId = _getChatId(message.senderId, message.receiverId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set({...message.toMap(), 'timestamp': FieldValue.serverTimestamp()});
  }

  Future<void> sendImageMessage({
    required String senderId,
    required String receiverId,
    required String imageUrl,
    String? caption,
  }) async {
    final message = MessageModel(
      id: const Uuid().v4(),
      senderId: senderId,
      receiverId: receiverId,
      text: caption ?? '',
      timestamp: DateTime.now().toUtc(),
      imageUrl: imageUrl,
      type: caption != null && caption.isNotEmpty
          ? MessageType.textWithImage
          : MessageType.image,
    );

    await sendMessage(message);
  }

  Stream<List<MessageModel>> listenToMessages(String myId, String contactId) {
    final chatId = _getChatId(myId, contactId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> markMessagesAsRead(String myId, String contactId) async {
    try {
      final chatId = _getChatId(myId, contactId);
      final query = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: myId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in query.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      if (query.docs.isNotEmpty) {
        await batch.commit();
      }
    } catch (e) {
      debugPrint('Error al marcar mensajes como leídos: $e');
    }
  }

  Future<void> markMessageAsRead(String messageId, String myId) async {
    try {
      final query = await _firestore
          .collectionGroup('messages')
          .where('id', isEqualTo: messageId)
          .where('receiverId', isEqualTo: myId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({'isRead': true});
      }
    } catch (e) {
      debugPrint('Error al marcar mensaje $messageId como leído: $e');
      await _markMessageByChat(messageId, myId);
    }
  }

  Future<void> _markMessageByChat(String messageId, String myId) async {
    try {
      final allChats = await _firestore.collection('chats').get();

      for (final chatDoc in allChats.docs) {
        try {
          final messageDoc = await chatDoc.reference
              .collection('messages')
              .doc(messageId)
              .get();

          if (messageDoc.exists && messageDoc.data()?['receiverId'] == myId) {
            await messageDoc.reference.update({'isRead': true});
            debugPrint('Mensaje marcado como leído en chat ${chatDoc.id}');
            return;
          }
        } catch (e) {
          continue;
        }
      }

      debugPrint('Mensaje $messageId no encontrado en ningún chat');
    } catch (e) {
      debugPrint('Error en marcado alternativo: $e');
    }
  }

  Stream<List<MessageModel>> listenToAllMessages(String myId) {
    final sentStream = _firestore
        .collectionGroup('messages')
        .where('senderId', isEqualTo: myId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );

    final receivedStream = _firestore
        .collectionGroup('messages')
        .where('receiverId', isEqualTo: myId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList(),
        );

    return sentStream.asyncExpand((sentMessages) {
      return receivedStream.map((receivedMessages) {
        final allMessages = [...sentMessages, ...receivedMessages];
        allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return allMessages;
      });
    });
  }

  String _getChatId(String id1, String id2) {
    final sorted = [id1, id2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
