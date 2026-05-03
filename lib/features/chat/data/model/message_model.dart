import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.productId,
    required super.senderUsername,
    required super.senderId,
    required super.text,
    required super.createdAt,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      productId: data['productId'],
      senderUsername: data['senderUsername'],
      senderId: data['senderId'],
      text: data['text'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'senderUsername': senderUsername,
    'senderId': senderId,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
