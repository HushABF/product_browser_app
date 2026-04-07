import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton(() => DioClient());
  // Phase 4: sl.registerLazySingleton(() => ProductRepository(sl()));
}
