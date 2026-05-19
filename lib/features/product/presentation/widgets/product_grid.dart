import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final String categorySlug;

  const ProductGrid({
    super.key,
    required this.products,
    required this.categorySlug,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text('No products found', style: TextStyles.font15GrayRegular),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.pushNamed(
            'productDetail',
            pathParameters: {
              'categorySlug': categorySlug,
              'productId': product.id.toString(),
            },
            extra: product,
          ),
        );
      },
    );
  }
}
