import 'package:flutter/material.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatelessWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: textTheme.titleSmall!.copyWith(fontWeight: .bold),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            // tileColor: Colors.grey.shade200,
            tileColor: colorScheme.secondaryFixed,
            leading: Image.network(product.thumbnail),
            title: Text(
              product.title,
              style: textTheme.bodySmall!.copyWith(fontWeight: .normal),
            ),
            subtitle: Text('\$${product.price.toString()}'),
            trailing: Text(
              'Rating: ${product.rating}',
              style: textTheme.bodySmall,
            ),
          ),
          Expanded(child: ListView.builder(itemBuilder: (context, index) {
            return ListTile()
          },))
        ],
      ),
    );
  }
}
