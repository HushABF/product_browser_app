import 'package:flutter/material.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const ProductBrowserApp());
}

class ProductBrowserApp extends StatelessWidget {
  const ProductBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Product Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
