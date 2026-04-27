import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';

class WatchMessagesUseCase {
  final ChatRepository chatRepository;

  WatchMessagesUseCase({required this.chatRepository});

  Stream<List<MessageEntity>> call({required String productId}) {
    return chatRepository.getMessages(productId: productId);
  }
}
