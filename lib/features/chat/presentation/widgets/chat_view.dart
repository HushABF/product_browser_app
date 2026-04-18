import 'package:flutter/material.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatelessWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(product.title)));
  }
}
