import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/domain/usecases/get_products_by_category_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

/// Bloc that manages product listing and local search.
///
/// - [FetchProductsByCategory] hits the API and stores results in [ProductSuccess.allProducts]
/// - [SearchProducts] filters [ProductSuccess.allProducts] locally — no extra API call
///   and is a no-operation if the current state is not [ProductSuccess]
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsByCategoryUseCase _getProductsByCategory;

  ProductBloc({required GetProductsByCategoryUseCase getProductsByCategory})
      : _getProductsByCategory = getProductsByCategory,
        super(const ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProductsByCategory(
    FetchProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _getProductsByCategory(event.slug);
    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      emit(ProductSuccess(allProducts: products, searchedProducts: products));
    });
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (state is! ProductSuccess) return;
    final current = state as ProductSuccess;
    final filtered = event.query.isEmpty
        ? current.allProducts
        : current.allProducts
              .where(
                (product) => product.title.toLowerCase().contains(
                  event.query.toLowerCase(),
                ),
              )
              .toList();
    emit(
      ProductSuccess(
        allProducts: current.allProducts,
        searchedProducts: filtered,
      ),
    );
    
  }
}
