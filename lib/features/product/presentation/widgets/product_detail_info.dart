import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/widgets/message_counter_bloc_builder.dart';

class ProductDetailInfo extends StatelessWidget {
  const ProductDetailInfo({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: TextStyles.font22DarkBlueBold),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyles.font17DarkBlueSemiBoldMono.copyWith(
                  color: ColorsManager.mainIndigo,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(Icons.star, size: 16.sp, color: ColorsManager.warning),
              SizedBox(width: 4.w),
              Text(
                product.rating.toString(),
                style: TextStyles.font13GrayMedium,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(product.description, style: TextStyles.font15GrayRegular),
          SizedBox(height: 24.h),
          BlocProvider(
            create: (context) =>
                getIt<MessageCounterCubit>()..watch(product.id.toString()),
            child: MessageCounterBlocBuilder(product: product),
          ),
        ],
      ),
    );
  }
}
