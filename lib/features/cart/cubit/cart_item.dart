import 'package:equatable/equatable.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}
