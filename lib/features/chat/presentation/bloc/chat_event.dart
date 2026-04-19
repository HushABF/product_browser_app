part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class WatchMessages extends ChatEvent {
  final String productId;
  const WatchMessages({required this.productId});

  @override
  List<Object> get props => [productId];
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

final class _StreamError extends ChatEvent {}