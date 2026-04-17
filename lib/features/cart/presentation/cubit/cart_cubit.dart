import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:product_browser_app/features/cart/domain/usecases/get_cart_use_case.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;
  final GetCartUseCase _getCartUseCase;

  CartCubit(this._repository, this._getCartUseCase) : super(const CartState()) {
    _load();
  }

  Future<void> _load() async {
    final items = await _getCartUseCase();
    emit(CartState(items: items));
  }

  Future<void> addToCart(CartItem item) async {
    final existing = state.items.any((i) => i.productId == item.productId);
    final updated = existing
        ? state.items
            .map((i) => i.productId == item.productId
                ? i.copyWith(quantity: i.quantity + item.quantity)
                : i)
            .toList()
        : [...state.items, item];
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }

  Future<void> decrementQuantity(int productId) async {
    final updated = state.items
        .map((i) => i.productId == productId
            ? i.copyWith(quantity: i.quantity - 1)
            : i)
        .toList();
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }

  Future<void> removeFromCart(int productId) async {
    final updated =
        state.items.where((i) => i.productId != productId).toList();
    emit(CartState(items: updated));
    await _repository.saveCart(updated);
  }
}
