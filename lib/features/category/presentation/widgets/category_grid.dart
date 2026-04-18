import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          category: categories[index],
          onTap: () => context.pushNamed(
            'productList',
            pathParameters: {'categorySlug': categories[index].slug},
          ),
        );
      },
    );
  }
}
