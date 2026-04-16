import 'package:equatable/equatable.dart';
import 'package:product_browser_app/features/cart/data/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  @override
  List<Object?> get props => [items];
}
