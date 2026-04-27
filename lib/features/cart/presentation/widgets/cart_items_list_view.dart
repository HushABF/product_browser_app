import 'package:flutter/material.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/widgets/cart_item_list_tile.dart';

class CartItemsListView extends StatelessWidget {
  const CartItemsListView({super.key, required this.items});

  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemListTile(item: item);
      },
    );
  }
}
