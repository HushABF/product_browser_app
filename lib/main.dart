import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/routes/app_router.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:product_browser_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:product_browser_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();
  await ScreenUtil.ensureScreenSize();
  runApp(const ProductBrowserApp());
}

class ProductBrowserApp extends StatelessWidget {
  const ProductBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(create: (_) => getIt<CartCubit>()),
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Product Browser',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorsManager.backgroundWhite,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: ColorsManager.backgroundWhite,
              foregroundColor: ColorsManager.darkBlue,
            ),
            cardTheme: const CardThemeData(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
            ),
          ),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
