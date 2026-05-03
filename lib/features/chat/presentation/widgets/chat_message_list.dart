import 'package:flutter/material.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ChatLoaded state;
  final ScrollController scrollController;

  const ChatMessageList({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: scrollController,
      itemCount: state.isLoadingMore
          ? state.messages.length + 1
          : state.messages.length,
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return MessageBubble(
          message: state.messages[index],
          currentUserId: state.currentUserId,
        );
      },
    );
  }
}
