import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/category/data/model/category_model.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';

part 'category_state.dart';

/// Cubit responsible for fetching and exposing the list of categories.
class CategoryCubit extends Cubit<CategoryState> {
  final ProductRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryInitial());

  /// Fetches all categories from the repository and emits the appropriate state.
  Future<void> fetchCategories() async {
    emit(const CategoryLoading());
    final result = await _repository.fetchCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategorySuccess(categories)),
    );
  }
}
