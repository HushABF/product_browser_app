import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository chatRepository;

  SendMessageUseCase({required this.chatRepository});

  Future<void> call({
    required String productId,
    required String senderUsername,
    required String text,
  }) {
    return chatRepository.sendMessage(
      productId: productId,
      senderUsername: senderUsername,
      text: text,
    );
  }
}
