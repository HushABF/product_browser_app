import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/product/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';
import 'package:product_browser_app/features/product/screens/widgets/product_view.dart';

class ProductListScreen extends StatelessWidget {
  final String categorySlug;

  const ProductListScreen({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(getIt<ProductRepository>())
        ..add(FetchProductsByCategory(categorySlug)),
      child: ProductView(categorySlug: categorySlug),
    );
  }
}
