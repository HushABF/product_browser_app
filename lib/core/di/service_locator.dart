import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/cart/data/cart_repository.dart';
import 'package:product_browser_app/features/product/data/product_repository_impl.dart';
import 'package:product_browser_app/features/product/domain/repositories/product_repository.dart';
import 'package:product_browser_app/features/product/domain/usecases/get_products_by_category_use_case.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsByCategoryUseCase(getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton(() => CartRepository());
}
