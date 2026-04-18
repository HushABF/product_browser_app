import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> loadCart();
  Future<void> saveCart(List<CartItem> items);
}
