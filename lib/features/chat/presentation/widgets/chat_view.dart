import 'package:flutter/material.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ChatView extends StatelessWidget {
  final ProductEntity product;
  const ChatView({super.key, required this.product});

  Widget _buildComment() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(child: Text('M')),
          SizedBox(width: 8),
          Expanded(
            // <-- key: gives Column bounded width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Mia O.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(' · 2h', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(
                  'Owned mine for 3 weeks. ANC is better than the \$400 competitors.',
                ),
              ],
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildComment();
              },
            ),
          ),
        ],
      ),
    );
  }
}
