import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/category/presentation/cubit/category_cubit.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_view.dart';
import 'package:product_browser_app/features/category/domain/usecases/get_categories_use_case.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(getIt<GetCategoriesUseCase>())..fetchCategories(),
      child: const CategoryView(),
    );
  }
}
