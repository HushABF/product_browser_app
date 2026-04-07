import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/product/data/product_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => ProductRepository(sl()));
}
