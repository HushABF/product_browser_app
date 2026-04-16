import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return badges.Badge(
          position: .topEnd(top: 3, end: 5),
          showBadge: state.itemCount > 0,
          badgeAnimation: badges.BadgeAnimation.slide(toAnimate: false),
          badgeContent: Text('${state.itemCount}', style: textTheme.labelSmall),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.pushNamed('cart'),
            tooltip: 'View cart',
          ),
        );
      },
    );
  }
}
