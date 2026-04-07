import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/category/screens/category_list_screen.dart';
import 'package:product_browser_app/features/cart/screens/cart_screen.dart';
import 'package:product_browser_app/features/product/screens/product_detail_screen.dart';
import 'package:product_browser_app/features/product/screens/product_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const CategoryListScreen(),
    ),
    GoRoute(
      name: 'productList',
      path: '/products/:categorySlug',
      builder: (context, state) {
        final slug = state.pathParameters['categorySlug']!;
        return ProductListScreen(categorySlug: slug);
      },
    ),
    GoRoute(
      name: 'productDetail',
      path: '/products/:categorySlug/:productId',
      builder: (context, state) => const ProductDetailScreen(),
    ),
    GoRoute(
      name: 'cart',
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);
