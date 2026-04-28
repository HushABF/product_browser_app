import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_browser_app/features/product/presentation/widgets/product_view_body_bloc_builder.dart';

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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search products...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: _onSearchChanged,
      ),
    );
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
          _buildSearchBar(),
          Expanded(
            child: ProductViewBodyBlocBuilder(
              categorySlug: widget.categorySlug,
            ),
          ),
        ],
      ),
    );
  }
}
