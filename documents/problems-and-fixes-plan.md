##  Issues Found in Review (2026-04-27)

### Chat feature
4. Duplicated `_currentUser` bootstrap — chat_bloc.dart:42-49 and chat_bloc.dart:71-78. Same null-check + fetch + emit-on-failure repeated in `_onWatch` and `_onSend`. Extract to a helper.
5. Firebase API keys committed — firebase_options.dart is tracked in git and contains live API keys/App IDs. Violates CLAUDE.md §A6 (no hardcoded secrets). `.gitignore` doesn't exclude it.
6. Large multi-responsibility widget — chat_view.dart handles scroll/pagination, send logic, message bubbles, product header, input bar, and BlocConsumer plumbing all in one file. Split into smaller widgets.
7. Silent stream errors in counter — message_counter_cubit.dart:22 swallows errors. CLAUDE.md §A3 forbids silent failures — at minimum emit an error state.

### Product feature
8. Hidden state coupling on `_allProducts` — product_bloc.dart:18,37-46. `SearchProducts` silently returns empty when fired before fetch. Either guard explicitly, model search inside the loaded state, or make the query part of fetch.

### Cart feature
9. No loading/error state during cart load — cart_cubit.dart:11-18. State starts empty; `_load()` is async; UI flashes "Your cart is empty". Storage errors are also swallowed. Needs a sealed `CartState` with `Loading`/`Loaded`/`Error`.
10. Business logic leakage into UI — cart_screen.dart:72-76. The `quantity > 1` rule lives in the widget. Move to the cubit (e.g., `decrementQuantity` no-ops or removes when at 1).
11. Cubit depends on repository, not use cases — cart_cubit.dart:11 takes `CartRepository` directly and calls `_repository.saveCart`. CLAUDE.md §B1 mandates "Cubits depend ONLY on use cases." Add `SaveCartUseCase` (and use cases for add/remove/update if appropriate) and remove the repo dependency.
12. Repository doesn't return `Either<Failure, T>` — cart_repository.dart returns raw `Future<List<CartItem>>` / `Future<void>`. CLAUDE.md §B5 requires `Either<Failure, T>` from domain. The `// TODO: add error handling using cache failure` comment in cart_repository_impl.dart:12 confirms it's unfinished. Also no try/catch around `jsonDecode`/`SharedPreferences`.
13. `GetCartUseCase` returns raw list — get_cart_use_case.dart:9 — same `Either` violation; will follow once the repo contract is fixed.

### Cross-cutting
14. `ProductBloc` constructor uses positional unnamed deps — minor; not a CLAUDE.md violation but inconsistent with other blocs/use cases that use named params.
