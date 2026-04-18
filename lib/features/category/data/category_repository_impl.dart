import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/category/data/model/category_model.dart';
import 'package:product_browser_app/features/category/domain/entities/category_entity.dart';
import 'package:product_browser_app/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final DioClient _dioClient;

  CategoryRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, List<CategoryEntity>>> fetchCategories() async {
    try {
      final response = await _dioClient.dio.get('/products/categories');
      final categories = (response.data as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(categories);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
