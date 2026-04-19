import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_browser_app/features/chat/data/model/message_model.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({required this.firestore});
  @override
  Stream<List<MessageEntity>> getMessages({required String productId}) {
    return firestore
        .collection('chats')
        .doc(productId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String productId,
    required String senderUsername,
    required String text,
  }) async {
    await firestore
        .collection('chats')
        .doc(productId)
        .collection('messages')
        .add({
          'productId': productId,
          'senderUsername': senderUsername,
          'text': text,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  @override
  Future<List<MessageEntity>> getOlderMessages({
    required String productId,
    required DateTime before,
    required int limit,
  }) async {
    final snapshot = await firestore
        .collection('chats')
        .doc(productId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .startAfter([Timestamp.fromDate(before)])
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => MessageModel.fromFirestore(doc)).toList();
  }
}
