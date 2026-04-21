import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages({required String productId});
  Future<Either<Failure, void>> sendMessage({
    required String productId,
    required String senderUsername,
    required String text,
  });

  Stream<int> getMessagesCount({required String productId});

  Future<Either<Failure, List<MessageEntity>>> getOlderMessages({
    required String productId,
    required DateTime before,
    required int limit,
  });
}
