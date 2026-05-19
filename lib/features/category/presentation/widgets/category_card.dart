import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  static Color accentFromSlug(String slug) {
    final hue = (slug.codeUnits.fold(0, (a, b) => a + b) % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.55).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final accent = accentFromSlug(category.slug);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(16.w),
        child: Text(
          category.name,
          style: TextStyles.font17DarkBlueSemiBold.copyWith(
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
