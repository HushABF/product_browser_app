import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/category/presentation/cubit/category_cubit.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_grid.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BROWSE',
                          style: TextStyles.font11LightGraySemiBold,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Discover',
                          style: TextStyles.font28DarkBlueBold,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile'),
                    icon: const Icon(Icons.person_outline),
                    color: ColorsManager.darkBlue,
                  ),
                  const CartBadgeButton(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) => switch (state) {
                  CategoryInitial() => const SizedBox.shrink(),
                  CategoryLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  CategoryError(:final message) => ErrorView(
                    message: message,
                    onRetry: () =>
                        context.read<CategoryCubit>().fetchCategories(),
                  ),
                  CategorySuccess(:final categories) => CategoryGrid(
                    categories: categories,
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
