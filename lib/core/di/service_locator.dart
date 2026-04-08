import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/cart/data/cart_repository.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton(() => ProductRepository(getIt()));
  getIt.registerLazySingleton(() => CartRepository());
}
