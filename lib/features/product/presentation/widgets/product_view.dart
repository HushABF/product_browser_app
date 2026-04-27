import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_grid.dart';

class ProductView extends StatefulWidget {
  final String categorySlug;

  const ProductView({super.key, required this.categorySlug});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<ProductBloc>().add(SearchProducts(query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorySlug),
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
              onChanged: _onSearchChanged,
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
                    FetchProductsByCategory(widget.categorySlug),
                  ),
                ),
                ProductSuccess(searchedProducts: final products) =>
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductBloc>().add(
                        FetchProductsByCategory(widget.categorySlug),
                      );
                      await context.read<ProductBloc>().stream.firstWhere(
                        (s) => s is! ProductLoading,
                      );
                    },
                    child: ProductGrid(
                      products: products,
                      categorySlug: widget.categorySlug,
                    ),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
