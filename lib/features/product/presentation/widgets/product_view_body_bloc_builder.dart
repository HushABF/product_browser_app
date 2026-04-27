import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_grid.dart';

class ProductViewBodyBlocBuilder extends StatelessWidget {
  const ProductViewBodyBlocBuilder({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) => switch (state) {
        ProductInitial() => const SizedBox.shrink(),
        ProductLoading() => const Center(child: CircularProgressIndicator()),
        ProductError(:final message) => ErrorView(
          message: message,
          onRetry: () => context.read<ProductBloc>().add(
            FetchProductsByCategory(categorySlug),
          ),
        ),
        ProductSuccess(searchedProducts: final products) => RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(
              FetchProductsByCategory(categorySlug),
            );
            await context.read<ProductBloc>().stream.firstWhere(
              (state) => state is! ProductLoading,
            );
          },
          child: ProductGrid(products: products, categorySlug: categorySlug),
        ),
      },
    );
  }
}
