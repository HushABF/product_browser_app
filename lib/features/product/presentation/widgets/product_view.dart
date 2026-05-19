import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorySlug, style: TextStyles.font22DarkBlueBold),
        actions: const [CartBadgeButton()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
            child: BlocBuilder<ProductBloc, ProductState>(
              buildWhen: (prev, curr) =>
                  curr is ProductSuccess || curr is ProductLoading,
              builder: (context, state) {
                if (state is ProductSuccess) {
                  return Text(
                    '${state.searchedProducts.length} products',
                    style: TextStyles.font13GrayRegular,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: ColorsManager.moreLighterGray,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyles.font15GrayRegular.copyWith(
                    color: ColorsManager.lightGray,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: ColorsManager.lightGray,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                style: TextStyles.font15GrayRegular.copyWith(
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
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
