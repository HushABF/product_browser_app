##  Issues Found in Review (2026-04-27)

### Chat feature
5. ✅ Firebase API keys committed — firebase_options.dart is tracked in git and contains live API keys/App IDs. Violates CLAUDE.md §A6 (no hardcoded secrets). `.gitignore` doesn't exclude it.
6. ✅ Large multi-responsibility widget — chat_view.dart handles scroll/pagination, send logic, message bubbles, product header, input bar, and BlocConsumer plumbing all in one file. Split into smaller widgets.
7. ✅ Silent stream errors in counter — message_counter_cubit.dart:22 swallows errors. CLAUDE.md §A3 forbids silent failures — at minimum emit an error state.

### Product feature
8. ✅ Hidden state coupling on `_allProducts` — product_bloc.dart:18,37-46. `SearchProducts` silently returns empty when fired before fetch. Either guard explicitly, model search inside the loaded state, or make the query part of fetch.

### Cart feature
9. No loading/error state during cart load — cart_cubit.dart:11-18. State starts empty; `_load()` is async; UI flashes "Your cart is empty". Storage errors are also swallowed. Needs a sealed `CartState` with `Loading`/`Loaded`/`Error`.
10. Business logic leakage into UI — cart_screen.dart:72-76. The `quantity > 1` rule lives in the widget. Move to the cubit (e.g., `decrementQuantity` no-ops or removes when at 1).
11. Cubit depends on repository, not use cases — cart_cubit.dart:11 takes `CartRepository` directly and calls `_repository.saveCart`. CLAUDE.md §B1 mandates "Cubits depend ONLY on use cases." Add `SaveCartUseCase` (and use cases for add/remove/update if appropriate) and remove the repo dependency.
12. Repository doesn't return `Either<Failure, T>` — cart_repository.dart returns raw `Future<List<CartItem>>` / `Future<void>`. CLAUDE.md §B5 requires `Either<Failure, T>` from domain. The `// TODO: add error handling using cache failure` comment in cart_repository_impl.dart:12 confirms it's unfinished. Also no try/catch around `jsonDecode`/`SharedPreferences`.
13. `GetCartUseCase` returns raw list — get_cart_use_case.dart:9 — same `Either` violation; will follow once the repo contract is fixed.

### Cross-cutting
14. `ProductBloc` constructor uses positional unnamed deps — minor; not a CLAUDE.md violation but inconsistent with other blocs/use cases that use named params.

---

# Fix Plan

## Context

The previously committed fixes left several CLAUDE.md violations and latent bugs across the chat, product, and cart features (see items 4–14 above). This plan groups the fixes into ordered phases so each phase produces a working app and unblocks the next.

## Phase 1 — Chat feature


### #5 Firebase secrets committed — `lib/firebase_options.dart`
**Options:**
- **A (Recommended)** — Add `lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, and `macos/Runner/GoogleService-Info.plist` to `.gitignore`; commit a `firebase_options.dart.example` template; document `flutterfire configure` in `README.md`. **Rotate the exposed Firebase API keys / app IDs in the Firebase console** (separate manual step the user must do).
- **B** — Read keys from `--dart-define` env vars and construct `FirebaseOptions` at runtime. More invasive; only needed if multiple environments are required.

> Note: removing the file from current `HEAD` does NOT remove it from git history. If the repo is public or has been shared, history rewrite (`git filter-repo`) is also required.

### #6 Large `chat_view.dart` widget
Split into:
- `widgets/product_header.dart` (existing `_buildProductHeader`)
- `widgets/message_bubble.dart` (existing `_buildComment`)
- `widgets/chat_input_bar.dart` (existing `_buildInputBar`, owns its `TextEditingController`)
- `widgets/chat_message_list.dart` (existing `_buildMessageList` + scroll/pagination logic and its `ScrollController`)
- `chat_view.dart` becomes a thin `Scaffold` + `BlocConsumer` shell.

Keeps each widget `const`-friendly and scopes `BlocBuilder`/`BlocConsumer` to the smallest subtree (CLAUDE.md §B7).

### #7 Silent stream errors — `lib/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart`
Add a sealed `MessageCounterState` (`Loading` / `Loaded(count)` / `Error(message)`) and emit `Error` from `onError`. Update `CartBadgeButton` / wherever it's consumed to handle the error case (likely just falls back to no badge).

## Phase 2 — Cart feature (architecture refactor)

This phase touches the most files; do it in one commit so layers stay consistent.

### #12 + #13 `Either<Failure, T>` contract — `lib/features/cart/{domain,data}/...`
- Change `CartRepository`:
  - `Future<Either<Failure, List<CartItem>>> loadCart()`
  - `Future<Either<Failure, void>> saveCart(List<CartItem> items)`
- Wrap `CartRepositoryImpl.loadCart`/`saveCart` in `try/catch`, mapping `FormatException`/`PlatformException` to a new `CacheFailure` in `core/errors/failures.dart` (check whether `CacheFailure` already exists first).
- Update `GetCartUseCase` to return `Either<Failure, List<CartItem>>`.

### #11 Cubit-uses-repository violation — `lib/features/cart/presentation/cubit/cart_cubit.dart`
**Options:**
- **A (Recommended)** — Introduce four use cases under `lib/features/cart/domain/usecases/`: `SaveCartUseCase`, `AddToCartUseCase`, `DecrementCartItemUseCase`, `RemoveFromCartUseCase`. Cubit depends only on use cases. Mirrors chat feature's pattern.
- **B** — Single `SaveCartUseCase`; cubit still computes the new list locally and calls save. Less ceremony but keeps mutation logic in the cubit.

Register use cases in `core/di/service_locator.dart`; remove `CartRepository` injection from `CartCubit`.

### #9 No loading/error state — `lib/features/cart/presentation/cubit/cart_state.dart` + `cart_cubit.dart`
Convert `CartState` to a sealed hierarchy:
```
sealed class CartState
  CartLoading
  CartLoaded({items, totalPrice, itemCount})
  CartError(message)
```
- `_load()` emits `CartLoading` → `CartLoaded` or `CartError`.
- All mutations operate on the current `CartLoaded` snapshot (no-op if not loaded yet).
- On save failure, recommend **revert the optimistic update + show snackbar via `BlocListener`**.
- Update `cart_screen.dart` to `switch` on the sealed state.

### #10 Business logic leakage — `lib/features/cart/presentation/screens/cart_screen.dart`
- Remove `item.quantity > 1` guard from the IconButton (L72-76); always call `decrementQuantity`.
- In `DecrementCartItemUseCase` / cubit: if the resulting quantity would be 0, remove the item instead. Single source of truth for the rule.

### Compile errors (carry-over)
While in `cart_screen.dart` and `chat_view.dart`, fix:
- `cart_screen.dart:111,118` — `fontWeight: .w600`/`.w700` → `FontWeight.w600`/`FontWeight.w700`
- `chat_view.dart:73` — `.end`/`.start` → `CrossAxisAlignment.end`/`CrossAxisAlignment.start`
- `chat_view.dart:119,203` — `.normal`/`.bold` → `FontWeight.normal`/`FontWeight.bold`

## Phase 3 — Product feature

### #8 Hidden `_allProducts` coupling — `lib/features/product/presentation/bloc/product_bloc.dart` + `product_state.dart`
**Options:**
- **A (Recommended)** — Hold the source list inside `ProductSuccess` itself: `ProductSuccess({allProducts, visibleProducts, query})`. `SearchProducts` becomes a no-op unless current state is `ProductSuccess`; field `_allProducts` is deleted. Eliminates the hidden coupling and makes the dependency type-checked.
- **B** — Guard `_onSearchProducts` with `if (_allProducts.isEmpty) return;` and document. Smallest change but doesn't fix the underlying design issue.
- **C** — Carry `query` in the fetch event and apply server-side. Overkill (API doesn't support it cleanly).

UI in `product_view.dart` switches on the new state shape (read `visibleProducts`).

## Phase 4 — Cross-cutting

### #14 `ProductBloc` named params
Change `ProductBloc(this._getProductsByCategory)` → `ProductBloc({required GetProductsByCategoryUseCase getProductsByCategory})` to match `ChatBloc`/`MessageCounterCubit`. Update `service_locator.dart` registration.

## Phase ordering rationale
1. **Phase 1** is independent and low-blast-radius — ship first.
2. **Phase 2** is the largest refactor (touches state shape, DI, use cases, screen) — isolate to one PR/commit so cart compiles end-to-end.
3. **Phase 3** depends on no other phase; can run in parallel with Phase 2 if branched separately.
4. **Phase 4** is trivial — bundle with Phase 3.

## Critical files
- `lib/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart`
- `lib/features/chat/presentation/widgets/chat_view.dart` (+ new widgets folder)
- `lib/features/chat/presentation/bloc/message_count_cubit/message_counter_cubit.dart` + state
- `lib/firebase_options.dart`, `.gitignore`, `README.md`
- `lib/features/cart/data/cart_repository_impl.dart`
- `lib/features/cart/domain/repositories/cart_repository.dart`
- `lib/features/cart/domain/usecases/*.dart` (new files)
- `lib/features/cart/presentation/cubit/cart_cubit.dart` + `cart_state.dart`
- `lib/features/cart/presentation/screens/cart_screen.dart`
- `lib/features/product/presentation/bloc/product_bloc.dart` + `product_state.dart`
- `lib/features/product/presentation/widgets/product_view.dart`
- `lib/core/errors/failures.dart` (verify/add `CacheFailure`)
- `lib/core/di/service_locator.dart`

## Reuse / existing patterns
- `dartz`'s `Either<Failure, T>` is already used in `chat`/`product` repos — mirror that exactly for cart.
- Sealed-state pattern is canonical in `chat_state.dart` and `product_state.dart` — copy the shape for the new `CartState` and `MessageCounterState`.
- `core/firebase/firebase_exception_handler.dart` and `core/network/` already centralise error mapping — model `CacheFailure` mapping similarly.
- `get_it` registration pattern in `service_locator.dart` — register new use cases as `LazySingleton`.

## Verification
- `flutter analyze` — must be clean (will catch the compile errors and any signature drift from the cart contract change).
- `flutter run` and manually exercise:
  - **Chat**: open product → see messages, send a message, scroll up to load older, kill network → see error state.
  - **Counter badge**: with network down, badge shows fallback (no crash).
  - **Cart**: cold-start → no "empty" flash; add item, decrement to 1 then again → item removed; force a save error → error surfaces.
  - **Product**: open category, type in search before fetch finishes → either waits or shows the prior state cleanly (no silent empty result).
- `git status` / `git ls-files lib/firebase_options.dart` — confirm secrets file is no longer tracked. **Manually verify keys are rotated in Firebase console.**
