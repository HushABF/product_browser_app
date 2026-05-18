import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/core/widgets/app_text_button.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/cart/presentation/widgets/cart_items_list_view.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Cart', style: TextStyles.font22DarkBlueBold),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final count = state is CartLoaded ? state.itemCount : 0;
              if (count == 0) return const SizedBox.shrink();
              return Center(
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.lightIndigo,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$count ${count == 1 ? 'item' : 'items'}',
                    style: TextStyles.font12LightGrayMedium.copyWith(
                      color: ColorsManager.mainIndigo,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => switch (state) {
          CartLoading() => const Center(child: CircularProgressIndicator()),
          CartError(:final message) => Center(
            child: Text(message, style: TextStyles.font15GrayRegular),
          ),
          CartLoaded(:final items) when items.isEmpty => _EmptyCartBody(),
          CartLoaded(:final items, :final totalPrice) => Column(
            children: [
              Expanded(child: CartItemsListView(items: items)),
              _TotalsSection(totalPrice: totalPrice),
            ],
          ),
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded || state.items.isEmpty) {
            return const SizedBox.shrink();
          }
          return _CheckoutBottomBar(totalPrice: state.totalPrice);
        },
      ),
    );
  }
}

class _EmptyCartBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              color: ColorsManager.moreLighterGray,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 40.sp,
              color: ColorsManager.lightGray,
            ),
          ),
          SizedBox(height: 24.h),
          Text('Nothing here yet', style: TextStyles.font22DarkBlueBold),
          SizedBox(height: 8.h),
          Text(
            'Items you add to your cart will appear here',
            style: TextStyles.font15GrayRegular,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: 200.w,
            child: AppTextButton(
              buttonText: 'Start browsing',
              onPressed: () => context.go('/'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsSection extends StatelessWidget {
  final double totalPrice;

  const _TotalsSection({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    const shippingCost = 0.0;
    final tax = totalPrice * 0.08;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ColorsManager.moreLightGray)),
      ),
      child: Column(
        children: [
          _TotalRow(
            label: 'Subtotal',
            value: '\$${totalPrice.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8.h),
          _TotalRow(
            label: 'Shipping',
            value: shippingCost == 0
                ? 'Free'
                : '\$${shippingCost.toStringAsFixed(2)}',
            valueStyle: TextStyles.font14DarkBlueSemiBold.copyWith(
              color: ColorsManager.success,
            ),
          ),
          SizedBox(height: 8.h),
          _TotalRow(label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _TotalRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.font15GrayRegular),
        Text(value, style: valueStyle ?? TextStyles.font14DarkBlueSemiBold),
      ],
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  final double totalPrice;

  const _CheckoutBottomBar({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final total = totalPrice + (totalPrice * 0.08);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        border: Border(top: BorderSide(color: ColorsManager.moreLightGray)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total', style: TextStyles.font13GrayRegular),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyles.font22DarkBlueBold,
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppTextButton(buttonText: 'Checkout', onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
