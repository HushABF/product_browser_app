import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/chat_message_list.dart';

void main() {
  final scrollController = ScrollController();

  testWidgets(
    'when ChatLoaded with messages is emitted, message bubbles appear in the list',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatMessageList(
              state: ChatLoaded(
                messages: [
                  MessageEntity(
                    id: '1',
                    productId: '1',
                    senderUsername: 'ahmed',
                    text: 'test message',
                    createdAt: DateTime(2025, 1, 1),
                    senderId: '1',
                  ),
                ],
                currentUserId: '1',
              ),
              scrollController: scrollController,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('test message'), findsOneWidget);
    },
  );
}
