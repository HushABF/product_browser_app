part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductSuccess extends ProductState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> searchedProducts;

  const ProductSuccess({
    required this.allProducts,
    required this.searchedProducts,
  });

  @override
  List<Object> get props => [allProducts, searchedProducts];
}

final class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
