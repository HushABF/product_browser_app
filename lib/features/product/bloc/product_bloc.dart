import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

/// Bloc that manages product listing and local search.
///
/// Two events share internal state:
/// - [FetchProductsByCategory] hits the API and stores results in [_allProducts]
/// - [SearchProducts] filters [_allProducts] locally — no extra API call
///
/// This inter-event dependency is why this is a Bloc, not a Cubit.
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  List<ProductModel> _allProducts = [];

  ProductBloc(this._repository) : super(const ProductInitial()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProductsByCategory(
    FetchProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await _repository.fetchProductsByCategory(event.slug);
    result.fold((failure) => emit(ProductError(failure.message)), (products) {
      _allProducts = products;
      emit(ProductSuccess(products));
    });
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (event.query.isEmpty) {
      emit(ProductSuccess(_allProducts));
      return;
    }
    final filtered = _allProducts
        .where((p) => p.title.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(ProductSuccess(filtered));
  }
}
