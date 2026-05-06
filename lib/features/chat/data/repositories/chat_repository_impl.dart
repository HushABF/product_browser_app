import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/firebase/firebase_exception_handler.dart';
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
        .handleError((error) {
          if (error is FirebaseException) {
            throw FirebaseExceptionHandler.handleFirebaseException(error);
          }
          throw FirebaseUnknownFailure(error.toString());
        })
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<int> getMessagesCount({required String productId}) {
    return firestore
        .collection('chats')
        .doc(productId)
        .collection('messages')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String productId,
    required String senderUsername,
    required String senderId,
    required String text,
  }) async {
    try {
      await firestore
          .collection('chats')
          .doc(productId)
          .collection('messages')
          .add({
            'productId': productId,
            'senderUsername': senderUsername,
            'senderId': senderId,
            'text': text,
            'createdAt': FieldValue.serverTimestamp(),
          });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getOlderMessages({
    required String productId,
    required DateTime before,
    required int limit,
  }) async {
    try {
      final snapshot = await firestore
          .collection('chats')
          .doc(productId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .startAfter([Timestamp.fromDate(before)])
          .limit(limit)
          .get();
      List<MessageEntity> olderMessages = snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
      return Right(olderMessages);
    } on FirebaseException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }
}
