import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';

class MockChatRepo extends Mock implements ChatRepository {}

void main() {
  late MockChatRepo mockChatRepo;
  late WatchMessagesUseCase watchMessagesUseCase;
  MessageEntity message1 = MessageEntity(
    id: '1',
    productId: '1',
    senderUsername: 'ahmed',
    text: 'test',
    createdAt: DateTime(2025, 1, 1),
    senderId: '1',
  );
  MessageEntity message2 = MessageEntity(
    id: '2',
    productId: '2',
    senderUsername: 'ahmed',
    text: 'test2',
    createdAt: DateTime(2025, 1, 1),
    senderId: '2',
  );

  setUp(() {
    mockChatRepo = MockChatRepo();
    watchMessagesUseCase = WatchMessagesUseCase(chatRepository: mockChatRepo);
  });

  test('return Stream from repository unchanged', () async {
    when(
      () => mockChatRepo.getMessages(productId: any(named: 'productId')),
    ).thenAnswer((_) => Stream.value([message1, message2]));
    
    final result = watchMessagesUseCase.call(productId: '1');

    verify(() => mockChatRepo.getMessages(productId: '1')).called(1);

    expect(result, emits([message1, message2]));
  });
}
