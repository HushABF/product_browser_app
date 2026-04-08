import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/features/cart/cubit/cart_item.dart';
import 'package:product_browser_app/features/cart/cubit/cart_state.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(ProductModel product) {
    final existing = state.items.any((i) => i.product.id == product.id);
    if (existing) {
      emit(
        CartState(
          items: state.items
              .map(
                (i) => i.product.id == product.id
                    ? CartItem(product: i.product, quantity: i.quantity + 1)
                    : i,
              )
              .toList(),
        ),
      );
    } else {
      emit(
        CartState(
          items: [
            ...state.items,
            CartItem(product: product, quantity: 1),
          ],
        ),
      );
    }
  }

  void decrementQuantity(int productId) {
    emit(
      CartState(
        items: state.items
            .map(
              (i) => i.product.id == productId
                  ? CartItem(product: i.product, quantity: i.quantity - 1)
                  : i,
            )
            .toList(),
      ),
    );
  }

  void removeFromCart(int productId) {
    emit(
      CartState(
        items: state.items.where((i) => i.product.id != productId).toList(),
      ),
    );
  }
}
