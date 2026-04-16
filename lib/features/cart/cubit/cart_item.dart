import 'package:equatable/equatable.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
      );

  @override
  List<Object?> get props => [product, quantity];
}
