import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/cubit/cart_state.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductModel product) {
    emit(CartState(items: [...state.items, product]));
  }

  void removeFromCart(int productId) {
    emit(CartState(
      items: state.items.where((p) => p.id != productId).toList(),
    ));
  }
}
