import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';

class DecrementCartItemUseCase {
  final CartRepository repository;

  DecrementCartItemUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call({
    required List<CartItem> currentItems,
    required int productId,
  }) async {
    final updated = currentItems
        .map((i) =>
            i.productId == productId ? i.copyWith(quantity: i.quantity - 1) : i)
        .where((i) => i.quantity > 0)
        .toList();
    final result = await repository.saveCart(updated);
    return result.fold(Left.new, (_) => Right(updated));
  }
}
