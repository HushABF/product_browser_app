import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';

class GetOlderMessagesUseCase {
  final ChatRepository chatRepository;

  GetOlderMessagesUseCase({required this.chatRepository});

  Future<List<MessageEntity>> call({
    required String productId,
    required DateTime before,
    required int limit,
  }) {
    return chatRepository.getOlderMessages(
      productId: productId,
      before: before,
      limit: limit,
    );
  }
}
