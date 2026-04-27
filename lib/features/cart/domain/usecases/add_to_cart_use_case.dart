import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call({
    required List<CartItem> currentItems,
    required CartItem item,
  }) async {
    final existing = currentItems.any((i) => i.productId == item.productId);
    final updated = existing
        ? currentItems
              .map(
                (i) => i.productId == item.productId
                    ? i.copyWith(quantity: i.quantity + item.quantity)
                    : i,
              )
              .toList()
        : [...currentItems, item];
    final result = await repository.saveCart(updated);
    return result.fold(Left.new, (_) => Right(updated));
  }
}
