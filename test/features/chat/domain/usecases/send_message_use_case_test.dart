import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';

class MockChatRepo extends Mock implements ChatRepository {}

void main() {
  late MockChatRepo mockChatRepo;
  late SendMessageUseCase sendMessageUseCase;

  setUp(() {
    mockChatRepo = MockChatRepo();
    sendMessageUseCase = SendMessageUseCase(chatRepository: mockChatRepo);
  });

  test(' Right(void) when message is sent successfully', () async {
    when(
      () => mockChatRepo.sendMessage(
        productId: any(named: 'productId'),
        senderUsername: any(named: 'senderUsername'),
        senderId: any(named: 'senderId'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) async => Right(null));

    final result = await sendMessageUseCase.call(
      productId: '1',
      senderUsername: 'ahmed',
      senderId: '1',
      text: 'test Message',
    );

    verify(
      () => mockChatRepo.sendMessage(
        productId: '1',
        senderUsername: 'ahmed',
        senderId: '1',
        text: 'test Message',
      ),
    ).called(1);

    expect(result, Right(null));
  });

  test('return Left(Failure) when repository fails', () async {
    when(
      () => mockChatRepo.sendMessage(
        productId: any(named: 'productId'),
        senderUsername: any(named: 'senderUsername'),
        senderId: any(named: 'senderId'),
        text: any(named: 'text'),
      ),
    ).thenAnswer(
      (_) async => Left(ServerFailure('Something went wrong', statusCode: 1)),
    );

    final result = await sendMessageUseCase.call(
      productId: '1',
      senderUsername: 'ahmed',
      senderId: '1',
      text: 'test Message',
    );

    verify(
      () => mockChatRepo.sendMessage(
        productId: '1',
        senderUsername: 'ahmed',
        senderId: '1',
        text: 'test Message',
      ),
    ).called(1);

    expect(result, isA<Left>());
  });
}
