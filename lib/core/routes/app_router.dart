import 'package:go_router/go_router.dart';
import 'package:product_browser_app/features/category/presentation/screens/category_list_screen.dart';
import 'package:product_browser_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:product_browser_app/features/product/presentation/screens/product_list_screen.dart';

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
      builder: (context, state) {
        final product = state.extra as ProductEntity;
        return ProductDetailScreen(product: product);
      },
    ),
    GoRoute(
      name: 'cart',
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);
