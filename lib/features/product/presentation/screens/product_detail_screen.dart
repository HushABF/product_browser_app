import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_detail_info.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_hero_image.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
            flexibleSpace: ProductHeroImage(imageUrl: product.images.first),
          ),
          SliverToBoxAdapter(child: ProductDetailInfo(product: product)),
        ],
      ),
    );
  }
}
