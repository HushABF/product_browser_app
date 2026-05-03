part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class WatchMessages extends ChatEvent {
  final String productId;
  final String currentUserId;
  final String currentUsername;
  const WatchMessages({
    required this.productId,
    required this.currentUserId,
    required this.currentUsername,
  });

  @override
  List<Object> get props => [productId, currentUserId, currentUsername];
}

final class SendMessage extends ChatEvent {
  final String productId;
  final String text;
  const SendMessage({required this.productId, required this.text});

  @override
  List<Object> get props => [productId, text];
}

final class _NewMessage extends ChatEvent {
  final List<MessageEntity> messages;

  const _NewMessage({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class _StreamError extends ChatEvent {
  final String errorMessage;

  const _StreamError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

final class LoadMoreMessages extends ChatEvent {
  final String productId;
  final DateTime before;

  const LoadMoreMessages({required this.productId, required this.before});
  @override
  List<Object> get props => [productId, before];
}
