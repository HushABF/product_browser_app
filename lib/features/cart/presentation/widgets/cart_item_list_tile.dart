import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';

class CartItemListTile extends StatelessWidget {
  const CartItemListTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: item.thumbnail,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, _, _) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () =>
                  context.read<CartCubit>().decrementQuantity(item.productId),
            ),
            Text(
              '${item.quantity}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.read<CartCubit>().addToCart(
                item.copyWith(quantity: 1),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  context.read<CartCubit>().removeFromCart(item.productId),
            ),
          ],
        ),
      ),
    );
  }
}
