import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String categorySlug;

  const ProductListScreen({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categorySlug)),
      body: const Center(child: Text('Product List — Phase 6b')),
    );
  }
}
