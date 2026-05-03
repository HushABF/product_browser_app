import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/chat_message_list.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/product_header.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatefulWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  bool _justSent = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ChatBloc>().state;
      if (state is ChatLoaded && !state.isLoadingMore && state.hasMore) {
        context.read<ChatBloc>().add(
          LoadMoreMessages(
            productId: widget.product.id.toString(),
            before: state.messages.last.createdAt,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title,
          style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          ProductHeader(product: widget.product),
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded &&
                    state.messages.isNotEmpty &&
                    !state.isLoadingMore &&
                    _justSent &&
                    state.messages.first.senderId == state.currentUserId) {
                  _justSent = false;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return ErrorView(message: state.errorMessage);
                } else if (state is ChatLoaded) {
                  return ChatMessageList(
                    state: state,
                    scrollController: _scrollController,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          ChatInputBar(
            productId: widget.product.id.toString(),
            onSent: () => _justSent = true,
          ),
        ],
      ),
    );
  }
}
