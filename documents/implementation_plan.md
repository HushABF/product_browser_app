# Product Browser App — Implementation Plan

## Context
Building a Flutter Product Browser App as a Week 2 training assignment. The goal is to learn Dio, BLoC/Cubit, and the Repository pattern by building a real 4-screen app against the DummyJSON API. The implementation is ordered for gradual learning — each phase introduces exactly one concern so the developer understands cause and effect before moving on.

Starting point: blank Flutter template, only `main.dart` exists, no dependencies added.

---

## Key Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Navigation | `go_router` | Developer already familiar; type-safe routes, industry standard |
| Theme | Material 3, `ColorScheme.fromSeed(Colors.indigo)` | Single seed, M3 generates full palette |
| DI | `get_it` lazy singletons | Satisfies "one shared Dio instance at app startup" requirement |
| Error handling | `dartz` `Either<Failure, T>` | Explicit error types in return signature; no try/catch in BLoC/Cubit |
| CategoryCubit scope | Screen-level | One action → one outcome; no inter-event memory needed |
| ProductBloc scope | Screen-level | Two events share `_allProducts` state — needs Bloc, not Cubit |
| CartCubit scope | Root-level via `MultiBlocProvider` | Must survive navigation; badge needed in every AppBar |
| State design | Dart 3 sealed classes, separate files | Exhaustive switch in UI, no boolean flags |
| Search | Local filter on `_allProducts` inside ProductBloc | No extra API call per keystroke (per assignment spec) |
| Images | `CachedNetworkImage` with placeholder + errorWidget | Avoids flicker, handles failures gracefully |

---

## Cubit vs Bloc Decision

| | Cubit | Bloc |
|---|---|---|
| **CategoryCubit** ✓ | `fetchCategories()` — one action, one outcome | — |
| **ProductBloc** ✓ | — | `FetchProductsByCategory` stores `_allProducts`; `SearchProducts` filters it — second event depends on first event's data |
| **CartCubit** ✓ | `addToCart()` / `removeFromCart()` — direct method calls | — |

---

## Packages

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  dio: ^5.4.0
  equatable: ^2.0.5
  cached_network_image: ^3.3.1
  badges: ^3.1.2
  shared_preferences: ^2.2.2
  go_router: ^14.0.0
  get_it: ^7.6.7
  dartz: ^0.10.1
```

---

## Folder Structure

```
lib/
  core/
    di/
      service_locator.dart
    errors/
      failures.dart
    network/
      dio_client.dart
    routes/
      app_router.dart
    widgets/
      cart_badge_button.dart
      error_view.dart
  features/
    category/
      data/
        category_model.dart
        category_repository.dart
      cubit/
        category_cubit.dart
        category_state.dart
      screens/
        category_list_screen.dart
        widgets/
          category_card.dart
    product/
      data/
        product_model.dart
        product_repository.dart
      bloc/
        product_bloc.dart
        product_event.dart
        product_state.dart
      screens/
        product_list_screen.dart
        product_detail_screen.dart
        widgets/
          product_card.dart
    cart/
      data/
        cart_repository.dart       ← optional (Phase 8d)
      cubit/
        cart_cubit.dart
        cart_state.dart
      screens/
        cart_screen.dart
```

---

## Git Branch Strategy

```
main          ← merge PRs in order
feature/*     ← one branch per phase, each built on top of the previous
```

**PR flow:** `feature/* → main` per phase, merged in order.

**Branches:**
```
feature/project-setup     ← Phase 1
feature/core-layer        ← Phase 2
feature/data-layer        ← Phase 3 (models + repositories for all features)
feature/category-feature  ← Phase 4 (CategoryCubit + Category screen)
feature/product-feature   ← Phase 5 (ProductBloc + Product screens)
feature/cart-feature      ← Phase 6 (CartCubit + Cart screen)
feature/polish-and-bonus  ← Phase 7 (polish + optional bonus features)
```

---

## Phase 1 — Project Setup
> **Branch:** `feature/project-setup`
> **Teaches:** pubspec, dependency management, go_router setup, get_it registration, M3 theming, folder-by-feature structure

### Files to create/modify
- `pubspec.yaml` — add all 9 packages
- `lib/core/di/service_locator.dart` — `setupLocator()` registering `DioClient` and `ProductRepository` as lazy singletons
- `lib/core/routes/app_router.dart` — `GoRouter` instance with 4 named routes, placeholder screens
- `lib/main.dart` — replace counter demo; call `setupLocator()` in `main()`; `ProductBrowserApp` with M3 theme, `MultiBlocProvider` (CartCubit), `MaterialApp.router`
- `lib/features/category/screens/category_list_screen.dart` — placeholder
- `lib/features/product/screens/product_list_screen.dart` — placeholder
- `lib/features/product/screens/product_detail_screen.dart` — placeholder
- `lib/features/cart/screens/cart_screen.dart` — placeholder

---

## Phase 2 — Core Layer (Network + Errors)
> **Branch:** `feature/core-layer`
> **Teaches:** Dio configuration, LogInterceptor, dartz Either, Failure sealed classes

### Files to create
- `lib/core/errors/failures.dart`
  - Sealed base class `Failure extends Equatable`
  - `NetworkTimeoutFailure` → `'Connection timed out. Please check your internet.'`
  - `ServerFailure({int? statusCode})` with `fromStatusCode` factory for per-status messages
  - `NetworkFailure(String message)` — general catch-all

- `lib/core/network/dio_client.dart`
  - `DioClient` class with single `Dio` instance
  - `baseUrl: 'https://dummyjson.com'`, `connectTimeout` + `receiveTimeout`: 10s
  - `LogInterceptor` (URL only, no body logging)
  - `static Failure handleDioException(DioException e)` — converts Dio errors to typed `Failure`

---

## Phase 3 — Data Layer (Models + Repositories)
> **Branch:** `feature/data-layer`
> **Teaches:** `fromJson` factory constructors, `Equatable` value equality, Repository pattern, `Either<Failure, T>` return types

### Files to create
- `lib/features/category/data/category_model.dart`
  - `Category(slug, name, url)` with `fromJson` factory

- `lib/features/product/data/product_model.dart`
  - `Product(id, title, description, price, rating, stock, thumbnail, images)`
  - ⚠️ `(json['price'] as num).toDouble()` — DummyJSON sometimes returns integer prices

- `lib/features/product/data/product_repository.dart`
  - `ProductRepository(DioClient _dioClient)`
  - `Future<Either<Failure, List<Category>>> fetchCategories()`
  - `Future<Either<Failure, List<Product>>> fetchProductsByCategory(String slug)`
  - Pattern per method:
    ```dart
    try {
      final response = await _dioClient.dio.get('/products/categories');
      final categories = (response.data as List)
          .map((e) => Category.fromJson(e))
          .toList();
      return Right(categories);
    } on DioException catch (e) {
      return Left(DioClient.handleDioException(e));
    }
    ```
  - **The only file that imports Dio. Cubit/Bloc never touch Dio directly.**

- Update `lib/core/di/service_locator.dart` — register `ProductRepository` as lazy singleton

---

## Phase 4 — Category Feature (Cubit + Screen)
> **Branch:** `feature/category-feature`
> **Teaches:** Cubit anatomy, `Either.fold()` in state management, BlocBuilder, GridView

### Files to create
```
lib/features/category/cubit/
  category_state.dart   → sealed: CategoryInitial | CategoryLoading | CategorySuccess(List<Category>) | CategoryError(String)
  category_cubit.dart   → fetchCategories() — emits loading → calls repo → folds Either → emits success or error

lib/features/category/screens/
  widgets/
    category_card.dart
  category_list_screen.dart
```

```dart
Future<void> fetchCategories() async {
  emit(CategoryLoading());
  final result = await _repository.fetchCategories();
  result.fold(
    (failure) => emit(CategoryError(failure.message)),
    (categories) => emit(CategorySuccess(categories)),
  );
}
```

**Screen:**
- `BlocProvider<CategoryCubit>` at screen root, calls `fetchCategories()` on create
- `BlocBuilder` with Dart 3 `switch` on sealed state
- `GridView.builder` (crossAxisCount: 2, childAspectRatio: 1.4) for success state
- `CircularProgressIndicator` for loading, `ErrorView` for error
- On tap: `context.pushNamed('productList', pathParameters: {'categorySlug': category.slug})`
- AppBar includes `CartBadgeButton`

**Shared widgets (create before screen):**
- `lib/core/widgets/cart_badge_button.dart`
- `lib/core/widgets/error_view.dart`

---

## Phase 5 — Product Feature (Bloc + Screens)
> **Branch:** `feature/product-feature`
> **Teaches:** Bloc with inter-event shared state, why `_allProducts` requires Bloc not Cubit, search filtering

### Files to create
```
lib/features/product/bloc/
  product_event.dart    → FetchProductsByCategory(String slug), SearchProducts(String query)
  product_state.dart    → sealed: ProductInitial | ProductLoading | ProductSuccess(List<Product>) | ProductError(String)
  product_bloc.dart     → holds List<Product> _allProducts
                          FetchProductsByCategory: hits API, stores in _allProducts, emits success
                          SearchProducts: filters _allProducts locally, emits success (no loading state)

lib/features/product/screens/
  widgets/
    product_card.dart
  product_list_screen.dart
  product_detail_screen.dart
```

**Product List Screen:**
- Receives `categorySlug` from go_router path param
- `BlocProvider<ProductBloc>`, fires `FetchProductsByCategory(slug)` on create
- `TextField` search bar → `onChanged` dispatches `SearchProducts(query)`
- `BlocBuilder` for 2-col `GridView`; empty list shows `'No products found'`
- On tap: `context.pushNamed('productDetail', pathParameters: {...}, extra: product)`
- AppBar includes `CartBadgeButton`

**Product Detail Screen:**
- Receives `Product` via go_router `extra`
- No local Bloc/Cubit — reads root `CartCubit` only
- `CustomScrollView` + `SliverAppBar` with first image from `product.images`
- Cart button via `BlocBuilder<CartCubit, CartState>` — toggles Add/Remove
- AppBar includes `CartBadgeButton`

---

## Phase 6 — Cart Feature (Cubit + Screen)
> **Branch:** `feature/cart-feature`
> **Teaches:** Immutable state updates, root-scoped Cubit, surviving navigation

### Files to create
```
lib/features/cart/cubit/
  cart_state.dart       → single CartState(List<Product> items) — NOT sealed
                          getters: double totalPrice, int itemCount
  cart_cubit.dart       → addToCart(Product) / removeFromCart(int productId)
                          always emit new CartState with new list — never mutate state.items

lib/features/cart/screens/
  cart_screen.dart
```

**Screen:**
- Reads root `CartCubit` — no local `BlocProvider`
- Empty state: cart icon + `'Your cart is empty'`
- `ListView.builder` with thumbnail, title, price, delete `IconButton`
- Bottom: `'Total: $formatted'` price display

Update `lib/main.dart`:
```dart
MultiBlocProvider(
  providers: [BlocProvider<CartCubit>(create: (_) => CartCubit())],
  child: MaterialApp.router(...),
)
```

---

## Phase 7 — Polish & Bonus (Optional)
> **Branch:** `feature/polish-and-bonus`

### Required
- Verify `CartBadgeButton` is in every screen's AppBar
- Verify `ErrorView` used in all error states with correct retry callback
- Finalize `AppBarTheme` (`scrolledUnderElevation: 0`) + `CardTheme` (`elevation: 0`, `clipBehavior: Clip.antiAlias`) in `main.dart`
- Remove redundant `elevation: 0` and `clipBehavior` from `CategoryCard` and `ProductCard` (now covered by theme)

### Bonus (Optional, each is independent)

**7a — Cart Quantity Counter**
Replace `List<Product>` with `List<CartItem(Product, int quantity)>` in `CartState`. `addToCart` increments if already exists. Show quantity controls in cart screen.

**7b — Pull-to-Refresh on Product List**
Wrap `GridView` in `RefreshIndicator`. `onRefresh` fires `FetchProductsByCategory` and awaits `bloc.stream.firstWhere((s) => s is! ProductLoading)`.

**7c — 300ms Search Debounce**
Convert product list screen to `StatefulWidget`. Use `dart:async` `Timer` in `onChanged`. Cancel in `dispose()`.

**7d — Cart Persistence via SharedPreferences**
Add `CartRepository` in `lib/features/cart/data/cart_repository.dart`. `CartCubit` loads cart on init, saves on every mutation.

---

## CachedNetworkImage pattern (use everywhere)
```dart
CachedNetworkImage(
  imageUrl: url,
  fit: BoxFit.cover,
  placeholder: (_, __) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
  ),
  errorWidget: (_, __, ___) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.broken_image),
  ),
)
```

---

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| `as double` crash on integer JSON price | `(json['price'] as num).toDouble()` |
| `context.read` in `build` causes no-rebuild | Use only in callbacks/`onPressed`; `BlocBuilder` for reactive UI |
| `CartCubit` not found in widget tree | `MultiBlocProvider` must **wrap** `MaterialApp.router`, not be inside it |
| go_router `extra` is null on deep link | `extra` doesn't survive app restart — acceptable for this project |
| Cubit/Bloc disposed twice | Never call `.close()` manually — `BlocProvider` auto-disposes |
| `Either` fold not exhaustive | Always handle both `Left` (failure) and `Right` (success) in every fold |

---

## Verification Checklist
- [ ] `flutter pub get` succeeds after Phase 1
- [ ] App launches to category grid (no crash) after Phase 4
- [ ] Tapping a category navigates to product grid via go_router
- [ ] Search filters products without loading spinner
- [ ] Cart badge increments/decrements in real time across all screens
- [ ] Disabling WiFi + retrying shows correct error message
- [ ] Cart items persist when navigating back and forward
