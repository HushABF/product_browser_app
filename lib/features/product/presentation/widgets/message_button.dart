import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({
    super.key,
    required this.colorScheme,
    required this.product,
  });

  final ColorScheme colorScheme;
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: colorScheme.primary,
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: () => context.pushNamed('chat', extra: product),
        icon: Icon(Icons.chat),
      ),
    );
  }
}
