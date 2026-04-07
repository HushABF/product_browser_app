import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Phase 2: sl.registerLazySingleton(() => DioClient());
  // Phase 4: sl.registerLazySingleton(() => ProductRepository(sl()));
}
