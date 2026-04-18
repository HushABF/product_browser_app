import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/use_cases/use_case.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';
import 'package:product_browser_app/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParam> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParam params) {
    return repository.fetchCategories();
  }
}
