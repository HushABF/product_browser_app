import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final count = state is CartLoaded ? state.itemCount : 0;
        return badges.Badge(
          position: badges.BadgePosition.topEnd(top: 3, end: 5),
          showBadge: count > 0,
          badgeAnimation: const badges.BadgeAnimation.slide(toAnimate: false),
          badgeStyle: const badges.BadgeStyle(
            badgeColor: ColorsManager.mainIndigo,
          ),
          badgeContent: Text(
            '$count',
            style: TextStyles.font11LightGraySemiBold.copyWith(
              color: Colors.white,
              fontSize: 10.sp,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: ColorsManager.darkBlue,
              size: 24.sp,
            ),
            onPressed: () => context.pushNamed('cart'),
            tooltip: 'View cart',
          ),
        );
      },
    );
  }
}
