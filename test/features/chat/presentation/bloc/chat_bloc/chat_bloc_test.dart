import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/usecases/get_older_messages_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';

class MockWatchMessagesUseCase extends Mock implements WatchMessagesUseCase {}

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

class MockGetOlderMessagesUseCase extends Mock
    implements GetOlderMessagesUseCase {}

void main() {
  late MockWatchMessagesUseCase mockWatchMessages;
  late MockSendMessageUseCase mockSendMessage;
  late MockGetOlderMessagesUseCase mockGetOlderMessages;
  late ChatBloc chatBloc;
  late StreamController<List<MessageEntity>> controller;

  setUp(() {
    mockWatchMessages = MockWatchMessagesUseCase();
    mockSendMessage = MockSendMessageUseCase();
    mockGetOlderMessages = MockGetOlderMessagesUseCase();

    chatBloc = ChatBloc(
      watchMessages: mockWatchMessages,
      sendMessage: mockSendMessage,
      getOlderMessages: mockGetOlderMessages,
    );
  });

  blocTest<ChatBloc, ChatState>(
    'WatchMessages emits ChatLoading then ChatLoaded when stream emits messages',
    setUp: () {
      when(
        () => mockWatchMessages.call(productId: any(named: 'productId')),
      ).thenAnswer((_) => Stream.value([]));
    },
    build: () => chatBloc,
    act: (bloc) => bloc.add(
      WatchMessages(
        productId: '1',
        currentUserId: '1',
        currentUsername: 'ahmed',
      ),
    ),
    expect: () => [ChatLoading(), ChatLoaded(messages: [], currentUserId: '1')],
  );

  blocTest<ChatBloc, ChatState>(
    'verify no further states are emitted after close',
    setUp: () {
      controller = StreamController<List<MessageEntity>>();
      when(
        () => mockWatchMessages.call(productId: any(named: 'productId')),
      ).thenAnswer((_) => controller.stream);
    },
    build: () => chatBloc,
    act: (bloc) async {
      bloc.add(
        WatchMessages(
          productId: '1',
          currentUserId: '1',
          currentUsername: 'ahmed',
        ),
      );
      //emit once before close
      controller.add([]);

      await Future.delayed(Duration(milliseconds: 50));
      await bloc.close();

      // emit after close — this should be ignored
      controller.add([
        MessageEntity(
          id: '2',
          productId: '2',
          senderUsername: 'test',
          text: 'text',
          createdAt: DateTime(2025, 1, 1),
          senderId: '2',
        ),
      ]);
    },
    expect: () => [ChatLoading(), ChatLoaded(messages: [], currentUserId: '1')],
  );
}
