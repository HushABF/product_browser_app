import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';

class WatchMessageCountUseCase {
  final ChatRepository repository;

  WatchMessageCountUseCase(this.repository);

  Stream<int> call({required String productId}) {
    return repository.getMessagesCount(productId: productId);
  }
}