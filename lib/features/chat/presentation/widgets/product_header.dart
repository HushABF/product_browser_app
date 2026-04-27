import 'package:flutter/material.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ProductHeader extends StatelessWidget {
  final ProductEntity product;

  const ProductHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      tileColor: colorScheme.secondaryFixed,
      leading: Image.network(product.thumbnail),
      title: Text(
        product.title,
        style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
      ),
      subtitle: Text('\$${product.price}'),
      trailing: Text(
        'Rating: ${product.rating}',
        style: textTheme.bodySmall,
      ),
    );
  }
}
