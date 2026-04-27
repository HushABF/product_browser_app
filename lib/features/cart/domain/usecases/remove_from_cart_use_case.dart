import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call({
    required List<CartItem> currentItems,
    required int productId,
  }) async {
    final updated =
        currentItems.where((i) => i.productId != productId).toList();
    final result = await repository.saveCart(updated);
    return result.fold(Left.new, (_) => Right(updated));
  }
}
