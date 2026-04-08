import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/cubit/cart_item.dart';
import 'package:product_browser_app/features/cart/cubit/cart_state.dart';
import 'package:product_browser_app/features/cart/data/cart_repository.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartState()) {
    _load();
  }

  Future<void> _load() async {
    final items = await _repository.loadCart();
    emit(CartState(items: items));
  }

  Future<void> addToCart(ProductModel product) async {
    final existing = state.items.any((i) => i.product.id == product.id);
    final updated = existing
        ? state.items
            .map((i) => i.product.id == product.id
                ? CartItem(product: i.product, quantity: i.quantity + 1)
                : i)
            .toList()
        : [...state.items, CartItem(product: product, quantity: 1)];
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }

  Future<void> decrementQuantity(int productId) async {
    final updated = state.items
        .map((i) => i.product.id == productId
            ? CartItem(product: i.product, quantity: i.quantity - 1)
            : i)
        .toList();
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }

  Future<void> removeFromCart(int productId) async {
    final updated =
        state.items.where((i) => i.product.id != productId).toList();
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }
}
