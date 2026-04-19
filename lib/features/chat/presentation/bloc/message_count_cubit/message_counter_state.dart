part of 'message_counter_cubit.dart';

sealed class MessageCounterState extends Equatable {
  const MessageCounterState();

  @override
  List<Object> get props => [];
}

final class MessageCounterInitial extends MessageCounterState {}
