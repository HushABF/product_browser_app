import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:product_browser_app/core/network/dio_client.dart';
import 'package:product_browser_app/features/cart/data/cart_repository_impl.dart';
import 'package:product_browser_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:product_browser_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/decrement_cart_item_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:product_browser_app/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/category/data/category_repository_impl.dart';
import 'package:product_browser_app/features/category/domain/repositories/category_repository.dart';
import 'package:product_browser_app/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:product_browser_app/features/category/presentation/cubit/category_cubit.dart';
import 'package:product_browser_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:product_browser_app/features/chat/data/repositories/user_repository_impl.dart';
import 'package:product_browser_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:product_browser_app/features/chat/domain/repositories/user_repository.dart';
import 'package:product_browser_app/features/chat/domain/usecases/get_older_messages_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/get_or_generate_username_usecase.dart';
import 'package:product_browser_app/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_message_count_use_case.dart';
import 'package:product_browser_app/features/chat/domain/usecases/watch_messages_use_case.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart';
import 'package:product_browser_app/features/product/data/product_repository_impl.dart';
import 'package:product_browser_app/features/product/domain/repositories/product_repository.dart';
import 'package:product_browser_app/features/product/domain/usecases/get_products_by_category_use_case.dart';
import 'package:product_browser_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:product_browser_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/watch_auth_state_use_case.dart';
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
  getIt.registerFactory(() => ProductBloc(getProductsByCategory: getIt()));

  // Category
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCategoriesUseCase(getIt<CategoryRepository>()),
  );
  getIt.registerFactory(() => CategoryCubit(getIt()));

  // Cart
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sharedPref: getIt()),
  );
  getIt.registerLazySingleton(() => GetCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => AddToCartUseCase(getIt<CartRepository>()));
  getIt.registerLazySingleton(
    () => DecrementCartItemUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => RemoveFromCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerLazySingleton(
    () => CartCubit(
      getCart: getIt(),
      addToCart: getIt(),
      decrementCartItem: getIt(),
      removeFromCart: getIt(),
    ),
  );

  // Chat
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(firestore: getIt()),
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sharedPref: getIt()),
  );
  getIt.registerLazySingleton(
    () => WatchMessagesUseCase(chatRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => SendMessageUseCase(chatRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetOrGenerateUsernameUsecase(userRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetOlderMessagesUseCase(chatRepository: getIt()),
  );
  getIt.registerFactory(
    () => ChatBloc(
      watchMessages: getIt(),
      sendMessage: getIt(),
      getOrGenerateUsername: getIt(),
      getOlderMessages: getIt(),
    ),
  );
  getIt.registerLazySingleton(
    () => WatchMessageCountUseCase(getIt<ChatRepository>()),
  );
  getIt.registerFactory(() => MessageCounterCubit(watchMessageCount: getIt()));

  // Auth
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton(() => LoginUseCase(authRepository: getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(authRepository: getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(authRepository: getIt()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(authRepository: getIt()));
  getIt.registerLazySingleton(() => WatchAuthStateUseCase(authRepository: getIt()));
}
