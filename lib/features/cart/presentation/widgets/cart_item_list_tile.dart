import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/core/widgets/quantity_stepper.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';

class CartItemListTile extends StatelessWidget {
  const CartItemListTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        color: ColorsManager.error,
        child: Icon(Icons.delete_outline, color: Colors.white, size: 24.sp),
      ),
      onDismissed: (_) =>
          context.read<CartCubit>().removeFromCart(item.productId),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: item.thumbnail,
                width: 72.w,
                height: 72.w,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 72.w,
                  height: 72.w,
                  color: ColorsManager.moreLighterGray,
                ),
                errorWidget: (_, _, _) => Container(
                  width: 72.w,
                  height: 72.w,
                  color: ColorsManager.moreLighterGray,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyles.font14DarkBlueSemiBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  QuantityStepper(
                    quantity: item.quantity,
                    onIncrement: () => context.read<CartCubit>().addToCart(
                      item.copyWith(quantity: 1),
                    ),
                    onDecrement: () => context
                        .read<CartCubit>()
                        .decrementQuantity(item.productId),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: TextStyles.font17DarkBlueSemiBoldMono.copyWith(
                color: ColorsManager.mainIndigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
