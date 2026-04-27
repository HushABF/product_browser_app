import 'package:equatable/equatable.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';

sealed class CartState extends Equatable {
  const CartState();
}

final class CartLoading extends CartState {
  const CartLoading();

  @override
  List<Object?> get props => [];
}

final class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({required this.items});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  @override
  List<Object?> get props => [items];
}

final class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
