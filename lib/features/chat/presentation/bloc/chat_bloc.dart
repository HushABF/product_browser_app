import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WatchMessagesUseCase _watchMessages;
  final SendMessageUseCase _sendMessage;
  StreamSubscription<List<MessageEntity>>? _sub;

  ChatBloc({
    required WatchMessagesUseCase watchMessages,
    required SendMessageUseCase sendMessage,
  }) : _watchMessages = watchMessages,
       _sendMessage = sendMessage,
       super(ChatInitial()) {
    on<WatchMessages>(_onWatch);
    on<SendMessage>(_onSend);
    on<_NewMessage>(_onNewMessages);
  }

  void _onWatch(WatchMessages event, Emitter<ChatState> emit) {
    _sub?.cancel();
    emit(ChatLoading());
    _sub = _watchMessages
        .call(productId: event.productId)
        .listen(
          (messages) => add(_NewMessage(messages: messages)),
          onError: (_) => emit(ChatError(errorMessage: 'Failed to load')),
        );
  }

  void _onNewMessages(_NewMessage event, Emitter<ChatState> emit) =>
      emit(ChatLoaded(messages: event.messages));

  Future<void> _onSend(SendMessage event, Emitter<ChatState> emit) async {
    await _sendMessage(
      productId: event.productId,
      senderUsername: event.senderUsername,
      text: event.text,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
