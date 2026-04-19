import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages({required String productId});
  Future<void> sendMessage({
    required String productId,
    required String senderUsername,
    required String text,
  });

  Stream<int> getMessagesCount({required String productId});

  Future<List<MessageEntity>> getOlderMessages({
    required String productId,
    required DateTime before,
    required int limit,
  });
}
