import 'package:go_router/go_router.dart';
import 'package:product_browser_app/core/di/service_locator.dart';
import 'package:product_browser_app/core/routes/go_router_refresh_stream.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:product_browser_app/features/auth/presentation/screens/edit_profile_screen.dart';
import 'package:product_browser_app/features/auth/presentation/screens/login_screen.dart';
import 'package:product_browser_app/features/auth/presentation/screens/register_screen.dart';
import 'package:product_browser_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:product_browser_app/features/category/presentation/screens/category_list_screen.dart';
import 'package:product_browser_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:product_browser_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:product_browser_app/features/product/domain/entities/product_entity.dart';
import 'package:product_browser_app/features/product/presentation/screens/product_detail_screen.dart';
import 'package:product_browser_app/features/product/presentation/screens/product_list_screen.dart';

final _authBloc = getIt<AuthBloc>();
final appRouter = GoRouter(
  initialLocation: '/splash',
  refreshListenable: GoRouterRefreshStream(stream: _authBloc.stream),
  redirect: (context, state) {
    final authState = _authBloc.state;
    final currentLocation = state.matchedLocation;
    const authOnlyRoutes = {'/login', '/register', '/splash'};

    if (authState is AuthInitial || authState is AuthLoading) {
      return currentLocation == '/splash' ? null : '/splash';
    }
    if (authState is AuthUnauthenticated) {
      return authOnlyRoutes.contains(currentLocation) ? null : '/login';
    }
    if (authState is AuthAuthenticated || authState is AuthUpdating) {
      return authOnlyRoutes.contains(currentLocation) ? '/' : null;
    }
    return null;
  },
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
    GoRoute(
      name: 'chat',
      path: '/chat',
      builder: (context, state) {
        final product = state.extra as ProductEntity;
        return ChatScreen(product: product);
      },
    ),
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
