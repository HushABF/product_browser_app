import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_message_count_use_case.dart';

part 'message_counter_state.dart';

class MessageCounterCubit extends Cubit<MessageCounterState> {
  final WatchMessageCountUseCase _watchMessageCount;
  StreamSubscription? _sub;

  MessageCounterCubit({required WatchMessageCountUseCase watchMessageCount})
    : _watchMessageCount = watchMessageCount,
      super(const MessageCounterLoading());

  void watch(String productId) {
    _sub?.cancel();
    _sub = _watchMessageCount(productId: productId).listen(
      (count) => emit(MessageCounterLoaded(count: count)),
      onError: (error) {
        emit(MessageCounterError(message: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
