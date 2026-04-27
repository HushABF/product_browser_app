import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/decrement_cart_item_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCart;
  final AddToCartUseCase _addToCart;
  final DecrementCartItemUseCase _decrementCartItem;
  final RemoveFromCartUseCase _removeFromCart;

  CartCubit({
    required GetCartUseCase getCart,
    required AddToCartUseCase addToCart,
    required DecrementCartItemUseCase decrementCartItem,
    required RemoveFromCartUseCase removeFromCart,
  })  : _getCart = getCart,
        _addToCart = addToCart,
        _decrementCartItem = decrementCartItem,
        _removeFromCart = removeFromCart,
        super(const CartLoading()) {
    _load();
  }

  Future<void> _load() async {
    final result = await _getCart();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items: items)),
    );
  }

  Future<void> addToCart(CartItem item) async {
    final current = state;
    if (current is! CartLoaded) return;
    final result = await _addToCart(currentItems: current.items, item: item);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (updated) => emit(CartLoaded(items: updated)),
    );
  }

  Future<void> decrementQuantity(int productId) async {
    final current = state;
    if (current is! CartLoaded) return;
    final result = await _decrementCartItem(
      currentItems: current.items,
      productId: productId,
    );
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (updated) => emit(CartLoaded(items: updated)),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final current = state;
    if (current is! CartLoaded) return;
    final result = await _removeFromCart(
      currentItems: current.items,
      productId: productId,
    );
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (updated) => emit(CartLoaded(items: updated)),
    );
  }
}
