import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          color: ColorsManager.moreLighterGray,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.w)),
        ),
        errorWidget: (_, _, _) => Container(
          color: ColorsManager.moreLighterGray,
          child: Icon(Icons.broken_image, size: 48.sp),
        ),
      ),
    );
  }
}
