import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/cart/data/cart_repository_impl.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:product_browser_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:product_browser_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';
import 'package:product_browser_app/features/product/data/product_repository_impl.dart';
import 'package:product_browser_app/features/product/domain/repositories/product_repository.dart';
import 'package:product_browser_app/features/category/data/category_repository_impl.dart';
import 'package:product_browser_app/features/category/domain/repositories/category_repository.dart';
import 'package:product_browser_app/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:product_browser_app/features/product/domain/usecases/get_products_by_category_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  getIt.registerLazySingleton(() => DioClient());
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  final sharedPref = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPref);

  // Product
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetProductsByCategoryUseCase(getIt<ProductRepository>()),
  );

  // Category
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt<CategoryRepository>()),
  );

  // Cart
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sharedPref: getIt()),
  );
  getIt.registerLazySingleton(() => GetCartUseCase(getIt<CartRepository>()));

  // Chat
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(firestore: getIt()),
  );
  getIt.registerLazySingleton(
    () => WatchMessagesUseCase(chatRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => SendMessageUseCase(chatRepository: getIt()),
  );
}
