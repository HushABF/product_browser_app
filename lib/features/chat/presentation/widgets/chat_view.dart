import 'package:flutter/material.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatelessWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  Widget _buildComment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: .end,
        children: [
          Text('Mohammed', style: Theme.of(context).textTheme.bodySmall),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            alignment: .center,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              'A curated shop and a quiet feed  curated shop and a quiet feed  curated shop and a quiet feed ',
            ),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return _buildComment(context);
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
