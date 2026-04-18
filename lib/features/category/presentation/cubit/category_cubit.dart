import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/use_cases/use_case.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';
import 'package:product_browser_app/features/category/domain/usecases/get_categories_use_case.dart';

part 'category_state.dart';

/// Cubit responsible for fetching and exposing the list of categories.
class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase _useCase;

  CategoryCubit(this._useCase) : super(const CategoryInitial());

  /// Fetches all categories from the repository and emits the appropriate state.
  Future<void> fetchCategories() async {
    emit(const CategoryLoading());
    final result = await _useCase(NoParam());
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategorySuccess(categories)),
    );
  }
}
