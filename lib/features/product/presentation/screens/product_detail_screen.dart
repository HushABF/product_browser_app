import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: BackButton(onPressed: () => context.pop()),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: const CartBadgeButton(),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.images.first,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Rating: ${product.rating}',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.description, style: textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          final inCart = state.items.any(
                            (i) => i.productId == product.id,
                          );
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
                      ),
                      SizedBox(width: 16),
                      BlocProvider(
                        create: (context) =>
                            getIt<MessageCounterCubit>()
                              ..watch(product.id.toString()),
                        child:
                            BlocBuilder<
                              MessageCounterCubit,
                              MessageCounterState
                            >(
                              builder: (context, state) {
                                return badges.Badge(
                                  position: .topEnd(top: -5, end: -8),
                                  showBadge: state.count > 0,
                                  badgeAnimation: badges.BadgeAnimation.slide(
                                    toAnimate: false,
                                  ),
                                  badgeContent: Text(
                                    '${state.count}',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),

                                  child: Container(
                                    decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      color: colorScheme.primary,
                                    ),
                                    child: IconButton(
                                      color: Colors.white,
                                      onPressed: () => context.pushNamed(
                                        'chat',
                                        extra: product,
                                      ),
                                      icon: Icon(Icons.chat),
                                    ),
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
