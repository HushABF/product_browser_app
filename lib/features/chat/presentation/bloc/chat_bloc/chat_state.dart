part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<MessageEntity> messages;
  final String currentUserId;
  final bool hasMore;
  final bool isLoadingMore;

  const ChatLoaded({
    required this.messages,
    required this.currentUserId,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [messages, currentUserId, hasMore, isLoadingMore];
}

final class ChatError extends ChatState {
  final String errorMessage;

  const ChatError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
