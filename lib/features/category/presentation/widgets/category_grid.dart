import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryEntity> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.1,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
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
