part of 'message_counter_cubit.dart';

sealed class MessageCounterState extends Equatable {
  const MessageCounterState();

  @override
  List<Object> get props => [];
}

final class MessageCounterLoading extends MessageCounterState {
  const MessageCounterLoading();
}

final class MessageCounterLoaded extends MessageCounterState {
  final int count;
  const MessageCounterLoaded({required this.count});

  @override
  List<Object> get props => [count];
}

final class MessageCounterError extends MessageCounterState {
  final String message;
  const MessageCounterError({required this.message});

  @override
  List<Object> get props => [message];
}
