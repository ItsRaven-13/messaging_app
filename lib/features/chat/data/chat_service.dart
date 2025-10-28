import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/features/chat/domain/models/message_model.dart';

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
