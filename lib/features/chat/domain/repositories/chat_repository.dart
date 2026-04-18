import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages({required String productId});
  Future<void> sendMessage({
    required String productId,
    required String senderUsername,
    required String text,
  });
}
