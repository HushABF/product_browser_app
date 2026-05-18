import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/widgets/app_text_button.dart';
import 'package:product_browser_app/core/widgets/quantity_stepper.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_detail_info.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_hero_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420.h,
            pinned: true,
            backgroundColor: ColorsManager.backgroundWhite,
            leading: Padding(
              padding: EdgeInsets.all(4.w),
              child: _GlassButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
            ),
            flexibleSpace: ProductHeroImage(
              imageUrl: widget.product.images.first,
            ),
          ),
          SliverToBoxAdapter(child: ProductDetailInfo(product: widget.product)),
        ],
      ),
      bottomNavigationBar: _StickyBottomBar(
        product: widget.product,
        quantity: _quantity,
        onIncrement: () => setState(() => _quantity++),
        onDecrement: () {
          if (_quantity > 1) setState(() => _quantity--);
        },
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}

class _StickyBottomBar extends StatelessWidget {
  final ProductEntity product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _StickyBottomBar({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        border: Border(top: BorderSide(color: ColorsManager.moreLightGray)),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final inCart =
                state is CartLoaded &&
                state.items.any((i) => i.productId == product.id);

            return Row(
              children: [
                QuantityStepper(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppTextButton(
                    buttonText: inCart ? 'Remove from Cart' : 'Add to Cart',
                    backgroundColor: inCart
                        ? ColorsManager.error
                        : ColorsManager.mainIndigo,
                    onPressed: () {
                      if (inCart) {
                        context.read<CartCubit>().removeFromCart(product.id);
                      } else {
                        context.read<CartCubit>().addToCart(
                          CartItem(
                            productId: product.id,
                            title: product.title,
                            thumbnail: product.thumbnail,
                            price: product.price,
                            quantity: quantity,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
