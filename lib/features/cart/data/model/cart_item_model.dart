import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.thumbnail,
    required super.price,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    productId: json['productId'] as int,
    title: json['title'] as String,
    thumbnail: json['thumbnail'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'title': title,
    'thumbnail': thumbnail,
    'price': price,
    'quantity': quantity,
  };
}
