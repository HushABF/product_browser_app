import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/widgets/chat_view.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatScreen extends StatelessWidget {
  final ProductEntity product;
  const ChatScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>()..add(WatchMessages(productId: product.id.toString())),
      child: ChatView(product: product),
    );
  }
}
