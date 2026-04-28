# CLAUDE.md

<!--
This file loads into context on EVERY message in this project.
Apply the Golden Test before adding any rule:
"Would removing this cause Claude to make mistakes?" If not — cut it.
Do not restate language defaults Claude already knows. Only write rules
that override defaults or encode decisions specific to this project.
-->

---

# Section A — General Engineering Rules

## 1) Architecture & Separation of Concerns (YOU MUST FOLLOW)
- Follow the project's architecture layer boundaries strictly: presentation → domain → data
- Never bypass layers or mix responsibilities
- UI/presentation layer has ZERO business logic — only rendering, interaction, and state observation
- Business logic lives in the domain layer
- Data access (APIs, databases, storage) lives in the data layer
- Do not introduce new abstractions or patterns without justification

## 2) Shared Code (IMPORTANT)
- Any reusable logic, utility, constant, extension, or helper used in 2+ places goes in `core/`
- Check `core/` before creating new shared code — never duplicate across features

## 3) Error Handling
- Errors flow cleanly across layers — never skip layers
- Handle null, empty, loading, and error states explicitly — no silent failures
- Catch errors at the boundary (data layer), not deep inside business logic

## 4) Change Discipline
- Make the smallest change that solves the problem
- Fix root causes, not symptoms
- Don't refactor unrelated code unless explicitly requested
- Never break existing functionality, APIs, flows, or UX unless explicitly instructed
- Read relevant code before modifying it — state assumptions when unclear

## 5) Dependencies
- Don't add new packages without justification
- Any new package must be: latest stable, well-maintained, production-grade

## 6) Security
- Never hardcode secrets, tokens, or credentials
- Never log sensitive information
- Validate all external and API input
- Proactively flag security risks when spotted

## 7) Testing (NOT NEEDED FOR NOW, SKIP)
- Write tests for domain and data layer logic
- Bug fixes must include a reproducing test
- Tests must be deterministic — no flaky or timing-dependent tests
- One behavior per test case

## 8) Workflow (Mandatory)
- Before marking any task done → run the `/code-review` skill

---

# Section B — Flutter / Dart Specific Rules

<!--
Follow official Dart style guide, Effective Dart, and `flutter_lints` defaults.
Rules below only cover things that OVERRIDE defaults or encode project decisions.
-->

## 1) State Management
- Use **Cubit/Bloc** for feature and application state — not Riverpod, Provider, or GetX
- Cubits depend ONLY on use cases — never directly on repositories or data sources
- `setState` is allowed ONLY for local UI state (e.g., toggles, form focus) — never for business logic
- Keep `setState` scoped to the smallest widget possible to avoid redundant rebuilds up the tree

## 2) No Code Generation
- **No Freezed. No build_runner.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data

## 3) Domain Layer Purity
- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`

## 4) Feature Folder Structure
- `features/{feature_name}/data/`
- `features/{feature_name}/domain/`
- `features/{feature_name}/presentation/`

## 5) Error Handling Contract
- Data layer: catch exceptions and map to typed `Failure` subclasses in `core/errors/failures.dart`
- Domain layer: use cases and repositories return `Either<Failure, T>` from `dartz`
- Map Dio errors via `core/network/` and Firebase errors via `core/firebase/firebase_exception_handler.dart` — never let raw exceptions cross into domain
- Presentation: pattern-match on the sealed `Failure` hierarchy to produce user-facing messages

## 6) Dependency Injection
- Use **`get_it`** as the service locator — not `Provider` or constructor-only injection
- Register dependencies in a single `core/di/` setup file
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

## 7) Build Method Discipline (IMPORTANT)
- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree

## 8) Routing
- Use **`go_router`** — all routes declared in `core/routes/app_router.dart`
- Never use `Navigator.push` with `MaterialPageRoute` directly; use `context.go` / `context.push`

## 9) Networking & Persistence
- REST calls go through the shared `DioClient` in `core/network/` — do not instantiate `Dio` ad-hoc
- Local persistence uses `shared_preferences` — wrap access behind a data source, never call it from presentation

## 10) State Classes
- Use `sealed class` + `final class` subclasses with `Equatable` for Bloc/Cubit states (see `chat_state.dart` as the canonical pattern)
- Always override `props` — do not rely on identity equality
