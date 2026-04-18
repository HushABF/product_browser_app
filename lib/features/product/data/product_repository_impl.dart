import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/network/dio_client.dart';

import 'package:product_browser_app/features/product/data/model/product_model/product_model.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _dioClient;

  ProductRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProductsByCategory(
    String slug,
  ) async {
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
