import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/category/presentation/cubit/category_cubit.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_grid.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Categories'),
        actions: const [CartBadgeButton()],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) => switch (state) {
          CategoryInitial() => const SizedBox.shrink(),
          CategoryLoading() => const Center(child: CircularProgressIndicator()),
          CategoryError(:final message) => ErrorView(
            message: message,
            onRetry: () => context.read<CategoryCubit>().fetchCategories(),
          ),
          CategorySuccess(:final categories) => CategoryGrid(
            categories: categories,
          ),
        },
      ),
    );
  }
}
