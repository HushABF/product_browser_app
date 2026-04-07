part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class FetchProductsByCategory extends ProductEvent {
  final String slug;

  const FetchProductsByCategory(this.slug);

  @override
  List<Object> get props => [slug];
}

final class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}
