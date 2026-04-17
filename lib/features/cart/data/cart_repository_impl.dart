import 'dart:convert';
import 'package:product_browser_app/features/cart/data/model/cart_item_model.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepositoryImpl implements CartRepository {
  static const _key = 'cart_items';

  @override
  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    // we need to serialize using CartItemModel
    final models = items.map((e) => CartItemModel(
      productId: e.productId,
      title: e.title,
      thumbnail: e.thumbnail,
      price: e.price,
      quantity: e.quantity,
    ).toJson()).toList();
    await prefs.setString(_key, jsonEncode(models));
  }
}
