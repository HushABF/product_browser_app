import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/cart/data/model/cart_item_model.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepositoryImpl implements CartRepository {
  final SharedPreferences sharedPref;
  static const _key = 'cart_items';

  CartRepositoryImpl({required this.sharedPref});

  @override
  Future<Either<Failure, List<CartItem>>> loadCart() async {
    try {
      final raw = sharedPref.getString(_key);
      if (raw == null) return const Right([]);
      final list = jsonDecode(raw) as List<dynamic>;
      final items = list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(items);
    } on FormatException catch (e) {
      return Left(CacheFailure('Failed to parse cart data: ${e.message}'));
    } catch (e) {
      return Left(CacheFailure('Failed to load cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCart(List<CartItem> items) async {
    try {
      final models = items
          .map(
            (e) => CartItemModel(
              productId: e.productId,
              title: e.title,
              thumbnail: e.thumbnail,
              price: e.price,
              quantity: e.quantity,
            ).toJson(),
          )
          .toList();
      await sharedPref.setString(_key, jsonEncode(models));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save cart: $e'));
    }
  }
}
