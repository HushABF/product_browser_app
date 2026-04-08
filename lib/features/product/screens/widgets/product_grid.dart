import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/product/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';
import 'package:product_browser_app/features/product/screens/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.pushNamed(
            'productDetail',
            pathParameters: {
              'categorySlug':
                  context.read<ProductBloc>().state is ProductSuccess
                  ? product.category
                  : '',
              'productId': product.id.toString(),
            },
            extra: product,
          ),
        );
      },
    );
  }
}
