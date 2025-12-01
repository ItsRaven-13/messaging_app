import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String receiverId;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final bool isRead;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final MessageType type;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.type = MessageType.text,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final ts = map['timestamp'];
    final parsed = ts is Timestamp
        ? ts.toDate().toUtc()
        : DateTime.fromMillisecondsSinceEpoch(
            (ts ?? DateTime.now().millisecondsSinceEpoch) as int,
            isUtc: true,
          );

    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      timestamp: parsed,
      isRead: map['isRead'] ?? false,
      imageUrl: map['imageUrl'],
      type: MessageType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'text'),
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toMap({bool useServerTime = false}) {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': useServerTime
          ? FieldValue.serverTimestamp()
          : timestamp.toUtc().millisecondsSinceEpoch,
      'isRead': isRead,
      'imageUrl': imageUrl,
      'type': type.name,
    };
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}

@HiveType(typeId: 3)
enum MessageType {
  @HiveField(0)
  text,

  @HiveField(1)
  image,

  @HiveField(2)
  textWithImage,
}
