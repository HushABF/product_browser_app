import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/chat_view.dart';

class ChatScreen extends StatelessWidget {
  final String productId;
  const ChatScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        watchMessages: getIt<WatchMessagesUseCase>(),
        sendMessage: getIt<SendMessageUseCase>(),
      )..add(WatchMessages(productId: productId)),
      child: ChatView(productId: productId),
    );
  }
}
