import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/domain/usecases/get_older_messages_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final WatchMessagesUseCase _watchMessages;
  final SendMessageUseCase _sendMessage;
  final GetOlderMessagesUseCase _getOlderMessages;
  late String _currentUserId;
  late String _currentUsername;
  StreamSubscription<List<MessageEntity>>? _sub;

  ChatBloc({
    required WatchMessagesUseCase watchMessages,
    required SendMessageUseCase sendMessage,
    required GetOlderMessagesUseCase getOlderMessages,
  }) : _getOlderMessages = getOlderMessages,
       _watchMessages = watchMessages,
       _sendMessage = sendMessage,
       super(ChatInitial()) {
    on<WatchMessages>(_onWatch);
    on<SendMessage>(_onSend);
    on<_NewMessage>(_onNewMessages);
    on<_StreamError>(_onStreamError);
    on<LoadMoreMessages>(_onLoadMore);
  }

  Future<void> _onWatch(WatchMessages event, Emitter<ChatState> emit) async {
    _currentUserId = event.currentUserId;
    _currentUsername = event.currentUsername;
    _sub?.cancel();
    emit(ChatLoading());
    _sub = _watchMessages
        .call(productId: event.productId)
        .listen(
          (messages) => add(_NewMessage(messages: messages)),
          onError: (error) {
            final message = error is Failure ? error.message : error.toString();
            add(_StreamError(errorMessage: message));
          },
        );
  }

  void _onNewMessages(_NewMessage event, Emitter<ChatState> emit) =>
      emit(ChatLoaded(messages: event.messages, currentUserId: _currentUserId));

  Future<void> _onSend(SendMessage event, Emitter<ChatState> emit) async {
    final result = await _sendMessage(
      productId: event.productId,
      senderUsername: _currentUsername,
      senderId: _currentUserId,
      text: event.text,
    );

    result.fold(
      (failure) => emit(ChatError(errorMessage: failure.message)),
      (_) => {},
    );
  }

  void _onStreamError(_StreamError event, Emitter<ChatState> emit) =>
      emit(ChatError(errorMessage: event.errorMessage));

  Future<void> _onLoadMore(
    LoadMoreMessages event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final currentState = state as ChatLoaded;
    if (currentState.isLoadingMore || !currentState.hasMore) return;
    emit(
      ChatLoaded(
        messages: currentState.messages,
        currentUserId: _currentUserId,
        hasMore: currentState.hasMore,
        isLoadingMore: true,
      ),
    );
    final olderMessages = await _getOlderMessages(
      productId: event.productId,
      before: event.before,
      limit: 20,
    );
    olderMessages.fold(
      (failure) => emit(ChatError(errorMessage: failure.message)),
      (olderMessages) {
        final hasMore = olderMessages.length == 20;
        final List<MessageEntity> mergedMessages = [
          ...currentState.messages,
          ...olderMessages,
        ];
        emit(
          ChatLoaded(
            messages: mergedMessages,
            currentUserId: _currentUserId,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
