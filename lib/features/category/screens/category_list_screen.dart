import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/widgets/cart_badge_button.dart';
import 'package:product_browser_app/core/widgets/error_view.dart';
import 'package:product_browser_app/features/category/cubit/category_cubit.dart';
import 'package:product_browser_app/features/category/data/model/category_model.dart';
import 'package:product_browser_app/features/category/screens/widgets/category_card.dart';
import 'package:product_browser_app/features/category/screens/widgets/category_grid.dart';
import 'package:product_browser_app/features/category/screens/widgets/category_view.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryCubit(getIt<ProductRepository>())..fetchCategories(),
      child: const CategoryView(),
    );
  }
}
