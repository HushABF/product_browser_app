import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/features/category/presentation/cubit/category_cubit.dart';
import 'package:product_browser_app/features/category/presentation/widgets/category_view.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>()..fetchCategories(),
      child: const CategoryView(),
    );
  }
}
