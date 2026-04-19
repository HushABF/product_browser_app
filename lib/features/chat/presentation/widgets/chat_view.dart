import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatefulWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool _justSent = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
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

  void _send() {
    final text = textEditingController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(
      SendMessage(productId: widget.product.id.toString(), text: text),
    );
    textEditingController.clear();
    _justSent = true;
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildComment({
    required MessageEntity message,
    required String currentUsername,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isMe = message.senderUsername == currentUsername;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: isMe ? .end : .start,
        children: [
          isMe
              ? const SizedBox.shrink()
              : Text(message.senderUsername, style: textTheme.bodySmall),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primary
                  : colorScheme.secondaryContainer,
              borderRadius: isMe
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isMe
                    ? colorScheme.onPrimary
                    : colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildProductHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return ListTile(
      tileColor: colorScheme.secondaryFixed,
      leading: Image.network(widget.product.thumbnail),
      title: Text(
        widget.product.title,
        style: textTheme.bodySmall!.copyWith(fontWeight: .normal),
      ),
      subtitle: Text('\$${widget.product.price.toString()}'),
      trailing: Text(
        'Rating: ${widget.product.rating}',
        style: textTheme.bodySmall,
      ),
    );
  }

  ListView _buildMessageList(ChatLoaded state) {
    return ListView.builder(
      reverse: true,
      controller: scrollController,
      itemCount: state.isLoadingMore
          ? state.messages.length + 1
          : state.messages.length,
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildComment(
          message: state.messages[index],
          currentUsername: state.currentUsername,
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 500,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Write a message…',
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton.filled(onPressed: _send, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title,
          style: textTheme.titleSmall!.copyWith(fontWeight: .bold),
        ),
      ),
      body: Column(
        children: [
          _buildProductHeader(colorScheme, textTheme),
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded &&
                    state.messages.isNotEmpty &&
                    !state.isLoadingMore &&
                    _justSent &&
                    state.messages.first.senderUsername ==
                        state.currentUsername) {
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
                  return _buildMessageList(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }
}
