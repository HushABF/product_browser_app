import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_counter_state.dart';

class MessageCounterCubit extends Cubit<MessageCounterState> {
  MessageCounterCubit() : super(MessageCounterInitial());
}
