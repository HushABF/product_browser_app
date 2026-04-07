import 'package:equatable/equatable.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartState extends Equatable {
  final List<ProductModel> items;

  const CartState({this.items = const []});

  int get itemCount => items.length;

  double get totalPrice => items.fold(0, (sum, p) => sum + p.price);

  @override
  List<Object?> get props => [items];
}
