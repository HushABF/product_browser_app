import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/chat/domain/entities/message_entity.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatefulWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  Widget _buildComment({
    required MessageEntity message,
    required String currentUsername,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: .end,
        children: [
          Text(message.senderUsername, style: textTheme.bodySmall),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            alignment: .center,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
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
          ListTile(
            // tileColor: Colors.grey.shade200,
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
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatError) {
                  return ErrorView(message: state.errorMessage);
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return _buildComment(
                        message: state.messages[index],
                        currentUsername: state.currentUsername,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField()),
              IconButton.filled(onPressed: () {}, icon: Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
