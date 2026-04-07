import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Cart icon button for AppBars.
///
/// Placeholder for Phase 4 — badge wiring with CartCubit is added in Phase 6.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart_outlined),
      onPressed: () => context.pushNamed('cart'),
      tooltip: 'View cart',
    );
  }
}
