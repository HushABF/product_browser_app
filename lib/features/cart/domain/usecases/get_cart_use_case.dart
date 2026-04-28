import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/cart/domain/entities/cart_item.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call() {
    return repository.loadCart();
  }
}
