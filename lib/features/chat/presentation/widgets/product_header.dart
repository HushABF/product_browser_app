import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';

class ProductHeader extends StatelessWidget {
  final ProductEntity product;

  const ProductHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorsManager.containerGray,
        border: Border(bottom: BorderSide(color: ColorsManager.moreLightGray)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: product.thumbnail,
              width: 48.w,
              height: 48.w,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 48.w,
                height: 48.w,
                color: ColorsManager.moreLighterGray,
              ),
              errorWidget: (_, _, _) => Container(
                width: 48.w,
                height: 48.w,
                color: ColorsManager.moreLighterGray,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyles.font14DarkBlueSemiBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyles.font13GrayMedium.copyWith(
                    color: ColorsManager.mainIndigo,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 14.sp, color: ColorsManager.warning),
              SizedBox(width: 4.w),
              Text(
                product.rating.toString(),
                style: TextStyles.font13GrayMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
