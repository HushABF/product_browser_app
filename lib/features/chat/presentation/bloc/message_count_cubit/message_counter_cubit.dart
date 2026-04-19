import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';

part 'message_counter_state.dart';

class MessageCounterCubit extends Cubit<MessageCounterState> {
  final WatchMessagesUseCase _watchMessages;
  StreamSubscription? _sub;
  MessageCounterCubit({required WatchMessagesUseCase watchMessages})
    : _watchMessages = watchMessages,
      super(MessageCounterState(count: 0));

  void watch(String productId) {
    _sub?.cancel();
    _sub = _watchMessages(
      productId: productId,
    ).listen((messages) => emit(MessageCounterState(count: messages.length)));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
