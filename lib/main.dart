import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/routes/app_router.dart';
import 'package:product_browser_app/features/cart/cubit/cart_cubit.dart';
import 'package:product_browser_app/features/cart/data/cart_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const ProductBrowserApp());
}

class ProductBrowserApp extends StatelessWidget {
  const ProductBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(create: (_) => CartCubit(getIt<CartRepository>())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Product Browser',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
          cardTheme: const CardThemeData(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
