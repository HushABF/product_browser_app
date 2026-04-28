import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class CartActionButton extends StatelessWidget {
  const CartActionButton({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final inCart =
            state is CartLoaded &&
            state.items.any((i) => i.productId == product.id);
        return Center(
          child: FilledButton.icon(
            onPressed: () {
              if (inCart) {
                context.read<CartCubit>().removeFromCart(
                  product.id,
                );
              } else {
                context.read<CartCubit>().addToCart(
                  CartItem(
                    productId: product.id,
                    title: product.title,
                    thumbnail: product.thumbnail,
                    price: product.price,
                    quantity: 1,
                  ),
                );
              }
            },
            icon: Icon(
              inCart
                  ? Icons.remove_shopping_cart_outlined
                  : Icons.shopping_cart_outlined,
            ),
            label: Text(
              inCart ? 'Remove from Cart' : 'Add to Cart',
            ),
          ),
        );
      },
    );
  }
}
