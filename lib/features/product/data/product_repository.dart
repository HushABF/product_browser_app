import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/category/data/model/category_model.dart';
import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';

class ProductRepository {
  final DioClient _dioClient;

  ProductRepository(this._dioClient);

  Future<Either<Failure, List<CategoryModel>>> fetchCategories() async {
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

  Future<Either<Failure, List<ProductModel>>> fetchProductsByCategory(String slug) async {
    try {
      final response = await _dioClient.dio.get('/products/category/$slug');
      final products = (response.data['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Right(products);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
