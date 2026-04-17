import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/use_cases/use_case.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/domain/repositories/product_repository.dart';

class GetProductsByCategoryUseCase extends UseCase<List<ProductEntity>, String>{
  final ProductRepository _repository;

  GetProductsByCategoryUseCase(this._repository);
  
  @override
  Future<Either<Failure, List<ProductEntity>>> call(String slug) {
        return _repository.fetchProductsByCategory(slug);

  }

  
}
