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

## Git Branch Strategy

```
main          ← for simplicity, push directly to main
feature/*     ← one branch per phase
```

**PR flow:** `feature/* → main` per phase.

**Branches:**
```
feature/project-setup
feature/core-layer
feature/data-models
feature/repository-layer
feature/category-cubit
feature/product-bloc
feature/cart-cubit
feature/category-screen
feature/product-list-screen
feature/product-detail-screen
feature/cart-screen
feature/polish
```

---

## Phase 1 — Project Setup
> **Branch:** `feature/project-setup`
> **Teaches:** pubspec, dependency management, go_router setup, get_it registration, M3 theming, folder-by-feature structure

### Files to create/modify
- `pubspec.yaml` — add all 9 packages
- `lib/core/di/service_locator.dart` — `setupLocator()` registering `DioClient` and `ProductRepository` as lazy singletons
- `lib/core/routes/app_router.dart` — `GoRouter` instance with 4 routes, placeholder screens
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
  - `ServerFailure({int? statusCode})` → `'Something went wrong on our end. Try again later.'`
  - `NetworkFailure(String message)` — general catch-all

- `lib/core/network/dio_client.dart`
  - `DioClient` class with single `Dio` instance
  - `baseUrl: 'https://dummyjson.com'`, `connectTimeout` + `receiveTimeout`: 10s
  - `LogInterceptor` (URL only, no body logging)
  - `static Failure handleDioException(DioException e)` — converts Dio errors to typed `Failure`

---

## Phase 3 — Data Models
> **Branch:** `feature/data-models`
> **Teaches:** `fromJson` factory constructors, `Equatable` value equality, safe JSON casting

### Files to create
- `lib/features/category/data/category_model.dart`
  - `Category(slug, name, url)` with `fromJson` factory

- `lib/features/product/models/product_model.dart`
  - `Product(id, title, description, price, rating, stock, thumbnail, images)`
  - ⚠️ `(json['price'] as num).toDouble()` — DummyJSON sometimes returns integer prices

---

## Phase 4 — Repository Layer
> **Branch:** `feature/repository-layer`
> **Teaches:** Repository pattern, `Either<Failure, T>` return types, isolating Dio from state management

### Files to create
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

---

## Phase 5 — State Management Layer

### 5a — CategoryCubit
> **Branch:** `feature/category-cubit`
> **Teaches:** Cubit anatomy, `Either.fold()` in state management

```
lib/features/category/cubit/
  category_state.dart   → sealed: CategoryInitial | CategoryLoading | CategorySuccess(List<Category>) | CategoryError(String)
  category_cubit.dart   → fetchCategories() — emits loading → calls repo → folds Either → emits success or error
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

### 5b — ProductBloc
> **Branch:** `feature/product-bloc`
> **Teaches:** Bloc with inter-event shared state, why `_allProducts` requires Bloc not Cubit

```
lib/features/product/bloc/
  product_event.dart    → FetchProductsByCategory(String slug), SearchProducts(String query)
  product_state.dart    → sealed: ProductInitial | ProductLoading | ProductSuccess(List<Product>) | ProductError(String)
  product_bloc.dart     → holds List<Product> _allProducts
                          FetchProductsByCategory: hits API, stores in _allProducts, emits success
                          SearchProducts: filters _allProducts locally, emits success (no loading state)
```

### 5c — CartCubit
> **Branch:** `feature/cart-cubit`
> **Teaches:** Immutable state updates, root-scoped Cubit

```
lib/features/cart/cubit/
  cart_state.dart       → single CartState(List<Product> items) — NOT sealed (no loading/error for cart)
                          getters: double totalPrice, int itemCount
  cart_cubit.dart       → addToCart(Product) / removeFromCart(int productId)
                          always emit new CartState with new list — never mutate state.items
```

Update `lib/main.dart` to provide `CartCubit` at root:
```dart
MultiBlocProvider(
  providers: [BlocProvider<CartCubit>(create: (_) => CartCubit())],
  child: MaterialApp.router(...),
)
```

---

## Phase 6 — UI Layer (Screen by Screen)
> **Teaches:** `BlocProvider`, `BlocBuilder`, `context.read`, widget extraction, `CachedNetworkImage`, go_router navigation

### Shared widgets (create in this phase before screens)
- `lib/core/widgets/cart_badge_button.dart` — `BlocBuilder<CartCubit, CartState>` + `Badge` + cart `IconButton` → reused in every AppBar
- `lib/core/widgets/error_view.dart` — error icon + message + `FilledButton.tonal('Retry', onPressed: onRetry)` → reused in all error states

### 6a — Category List Screen
> **Branch:** `feature/category-screen`

`lib/features/category/screens/category_list_screen.dart`
- `BlocProvider<CategoryCubit>` at screen root, calls `fetchCategories()` on create
- `BlocBuilder` with Dart 3 `switch` on sealed state
- `GridView.builder` (crossAxisCount: 2, childAspectRatio: 1.4) for success state
- `CircularProgressIndicator` for loading, `ErrorView` for error
- Extract: `lib/features/category/screens/widgets/category_card.dart`
- On tap: `context.push('/products/${category.slug}')`
- AppBar includes `CartBadgeButton`

### 6b — Product List Screen
> **Branch:** `feature/product-list-screen`

`lib/features/product/screens/product_list_screen.dart`
- Receives `categorySlug` from go_router path param
- `BlocProvider<ProductBloc>`, fires `FetchProductsByCategory(slug)` on create
- `TextField` search bar at top → `onChanged` dispatches `SearchProducts(query)`
- `BlocBuilder` for 2-col `GridView`; empty list inside `ProductSuccess` shows `'No products found'`
- Extract: `lib/features/product/screens/widgets/product_card.dart`
- On tap: `context.push('/products/$slug/${product.id}', extra: product)`
- AppBar includes `CartBadgeButton`

### 6c — Product Detail Screen
> **Branch:** `feature/product-detail-screen`

`lib/features/product/screens/product_detail_screen.dart`
- Receives `Product` via go_router `extra`
- **No local Bloc/Cubit** — reads root `CartCubit` only
- `CustomScrollView` + `SliverAppBar` (expandable, pinned) with first image from `product.images`
- Body: title, price (formatted), rating, stock indicator, description
- Cart button via `BlocBuilder<CartCubit, CartState>`:
  ```dart
  final isInCart = cartState.items.any((p) => p.id == product.id);
  // 'Add to Cart' or 'Remove from Cart'
  ```
- AppBar includes `CartBadgeButton`

### 6d — Cart Screen
> **Branch:** `feature/cart-screen`

`lib/features/cart/screens/cart_screen.dart`
- Reads root `CartCubit` — no local `BlocProvider` needed
- Empty state: cart icon + `'Your cart is empty'` + back button
- Item list: `ListView.builder` with thumbnail, title, price, delete `IconButton`
- Bottom: `'Total: $formatted'` price display

### CachedNetworkImage pattern (use everywhere)
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

## Phase 7 — Polish
> **Branch:** `feature/polish`

- Verify `CartBadgeButton` is in every screen's AppBar
- Verify `ErrorView` used in all error states with correct retry callback
- Use `BadgeAnimation.none()` on cart badge
- Finalize `AppBarTheme` + `CardTheme` in `main.dart` via `ThemeData.copyWith`

---

## Phase 8 — Bonus (Optional, each is independent)

**8a — Cart Quantity Counter**
Replace `List<Product>` with `List<CartItem(Product, int quantity)>` in `CartState`. `addToCart` increments if already exists. Show quantity controls in cart screen.

**8b — Pull-to-Refresh on Product List**
Wrap `GridView` in `RefreshIndicator`. `onRefresh` fires `FetchProductsByCategory` and awaits `bloc.stream.firstWhere((s) => s is! ProductLoading)`.

**8c — 300ms Search Debounce**
Convert product list screen to `StatefulWidget`. Use `dart:async` `Timer` in `onChanged`. Cancel in `dispose()`.

**8d — Cart Persistence via SharedPreferences**
Add `CartRepository` in `lib/features/cart/data/cart_repository.dart`. Add `toJson()` to `Product`. `CartCubit` loads cart on init, saves on every mutation.

---

## File Creation Order (strict dependency order)

```
Phase 1 (feature/project-setup):
  pubspec.yaml
  lib/core/di/service_locator.dart
  lib/core/routes/app_router.dart
  lib/main.dart
  lib/features/*/screens/*_screen.dart  ← 4 placeholders

Phase 2 (feature/core-layer):
  lib/core/errors/failures.dart
  lib/core/network/dio_client.dart

Phase 3 (feature/data-models):
  lib/features/category/data/category_model.dart
  lib/features/product/models/product_model.dart

Phase 4 (feature/repository-layer):
  lib/features/product/data/product_repository.dart

Phase 5a (feature/category-cubit):
  lib/features/category/cubit/category_state.dart
  lib/features/category/cubit/category_cubit.dart

Phase 5b (feature/product-bloc):
  lib/features/product/bloc/product_event.dart
  lib/features/product/bloc/product_state.dart
  lib/features/product/bloc/product_bloc.dart

Phase 5c (feature/cart-cubit):
  lib/features/cart/cubit/cart_state.dart
  lib/features/cart/cubit/cart_cubit.dart
  lib/main.dart  ← updated with MultiBlocProvider

Phase 6 (feature/*-screen):
  lib/core/widgets/cart_badge_button.dart
  lib/core/widgets/error_view.dart
  lib/features/category/screens/widgets/category_card.dart
  lib/features/category/screens/category_list_screen.dart
  lib/features/product/screens/widgets/product_card.dart
  lib/features/product/screens/product_list_screen.dart
  lib/features/product/screens/product_detail_screen.dart
  lib/features/cart/screens/cart_screen.dart
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
- [ ] App launches to category grid (no crash) after Phase 6a
- [ ] Tapping a category navigates to product grid via go_router
- [ ] Search filters products without loading spinner
- [ ] Cart badge increments/decrements in real time across all screens
- [ ] Disabling WiFi + retrying shows correct error message
- [ ] Cart items persist when navigating back and forward
