part of 'message_counter_cubit.dart';

 class MessageCounterState extends Equatable {
  final int count;
  const MessageCounterState({required this.count});

  @override
  List<Object> get props => [count];
}

