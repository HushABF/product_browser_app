import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/product/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/screens/widgets/product_grid.dart';

class ProductView extends StatelessWidget {
  final String categorySlug;

  const ProductView({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categorySlug),
        actions: const [CartBadgeButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) =>
                  context.read<ProductBloc>().add(SearchProducts(query)),
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) => switch (state) {
                ProductInitial() => const SizedBox.shrink(),
                ProductLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProductError(:final message) => ErrorView(
                  message: message,
                  onRetry: () => context.read<ProductBloc>().add(
                    FetchProductsByCategory(categorySlug),
                  ),
                ),
                ProductSuccess(:final products) => ProductGrid(
                  products: products,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
