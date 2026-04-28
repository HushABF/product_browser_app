import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/cart/presentation/widgets/cart_items_list_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => switch (state) {
          CartLoading() => const Center(child: CircularProgressIndicator()),
          CartError(:final message) => Center(child: Text(message)),
          CartLoaded(:final items) when items.isEmpty => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 64),
                SizedBox(height: 16),
                Text('Your cart is empty'),
              ],
            ),
          ),
          CartLoaded(:final items, :final totalPrice) => Column(
            children: [
              Expanded(child: CartItemsListView(items: items)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}
