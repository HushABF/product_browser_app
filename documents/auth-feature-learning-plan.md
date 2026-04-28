# Auth Feature — Implementation Phases

High-level phases and the key decisions to make in each. Pick a phase, think through the decisions yourself, then come discuss the details.

---

## Phase 1 — Domain layer

Define the shape of the feature in pure Dart.

**Decisions to make:**
- What fields belong on `AppUser`? (id, email, username — what about photoUrl now or later?)
- Which methods does `AuthRepository` need? Think about every user action + app-start.
- Is auth state a `Stream` or a one-shot `Future`? (Affects how the bloc reacts to logout from other devices, token expiry, etc.)
- One use case per repository method, or group some?

**My answers:**

`AppUser` entity:
```dart
class AppUser {
  final String id;
  final String email;
  final String username;
  final String? photoUrl;
}
```

`AuthRepository`:
```dart
abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<Either<Failure, AppUser>> registerWithEmailAndPassword(String email, String password, String username);
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(String email, String password);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, AppUser>> updateProfile({String? username, String? photoUrl});
}
```

Failure types:
```dart
abstract class Failure {}
class InvalidCredentialsFailure extends Failure {}
class EmailAlreadyInUseFailure extends Failure {}
class WeakPasswordFailure extends Failure {}
class InvalidEmailFailure extends Failure {}
class UserDisabledFailure extends Failure {}
class TooManyRequestsFailure extends Failure {}
class NetworkFailure extends Failure {}
class UnexpectedFailure extends Failure {}
```

Use cases — one per repository method. `RegisterUseCase` orchestrates both `createUserWithEmailAndPassword` and `updateDisplayName` internally.

---

## Phase 2 — Data layer

Implement the repository against Firebase.

**Decisions to make:**
- Which `FirebaseAuthException` codes do you care about, and what `Failure` does each map to?
- Where does the username live? Firebase Auth has `displayName` but no native "username" — do you treat them as the same field, or also store a separate username somewhere (Firestore)?
- How do you build an `AppUser` from a `User?` — what do you do when `displayName` is null right after register?
- Register flow: do you call `createUserWithEmailAndPassword` then `updateDisplayName` in sequence? What if the second call fails?

**My answers:**
- Map `FirebaseAuthException` codes to the `Failure` types above.
- `displayName` is treated as username — no Firestore needed.
- `AppUser` is built manually in the register method using the form data, never reading `displayName` back from Firebase.
- Register flow: if `updateDisplayName` fails after `createUserWithEmailAndPassword` succeeds, delete the orphaned account and return `UnexpectedFailure`.

---

## Phase 3 — Presentation: AuthBloc

Define events, states, and how the bloc reacts to the auth stream.

**Decisions to make:**
- What events do you need? (Started, LoginRequested, RegisterRequested, LogoutRequested, ProfileUpdateRequested, UserChanged…)
- What states? The task spec lists five — is that enough, or do you want a separate `AuthUpdating` for profile-save spinners?
- How does the bloc subscribe to `authStateChanges`? `emit.forEach`, manual `StreamSubscription`, or an internal `UserChanged` event?
- Does the bloc handle navigation, or just emit state? (Pick one rule and stick to it.)

**My answers:**

Events:
```dart
class AuthStarted extends AuthEvent {}
class UserChanged extends AuthEvent { final AppUser? user; }
class LoginRequested extends AuthEvent { final String email, password; }
class RegisterRequested extends AuthEvent { final String email, password, username; }
class LogoutRequested extends AuthEvent {}
class ProfileUpdateRequested extends AuthEvent { final String? username, photoUrl; }
```

States:
```dart
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState { final AppUser user; }
class AuthUnauthenticated extends AuthState {}
class AuthUpdating extends AuthState { final AppUser user; }
class AuthFailure extends AuthState { final Failure failure; }
```

- Stream subscription — manual `StreamSubscription`. Pushes emissions as `UserChanged` events. Cancelled in `close()`.
- Registration guard — `_isRegistering` flag blocks `UserChanged` from overwriting correct state during registration. Flag turns false only when stream delivers a user with non-null displayName.
- Navigation — bloc never navigates. Emits state only.

> **Caveat to revisit:** `FirebaseAuth.authStateChanges()` does **not** fire on `updateDisplayName` — only on sign-in/sign-out. The "wait for displayName != null" guard will hang against that stream. Switch the repository to `userChanges()`, which fires on profile updates too.

---

## Phase 4 — DI wiring

Register everything in `service_locator.dart`.

**Decisions to make:**
- `AuthBloc`: singleton (one instance app-wide so the router can read it) or factory (new per screen)?
- Where does `FirebaseAuth.instance` get injected — at the repository constructor, or grabbed inside it?

**My answers:**
```dart
sl.registerLazySingleton(() => FirebaseAuth.instance);

sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(sl<FirebaseAuth>()),
);

sl.registerLazySingleton(
  () => AuthBloc(sl<AuthRepository>()),
);
```
- `AuthBloc` is a singleton — one instance app-wide.
- `FirebaseAuth.instance` injected at repository constructor for testability.

---

## Phase 5 — Screens

Build Login, Register, Edit Profile.

**Decisions to make:**
- Validation rules: min password length? Username format? Email regex or just `contains('@')`?
- One shared `BlocConsumer` pattern across all three screens, or per-screen handling?
- Loading UX: disable the button, show a spinner inside it, or a full-screen overlay?
- Error UX: SnackBar, inline text below the field, or a dialog?
- Edit Profile: save button always enabled, or only when the username actually changed?

**My answers:**
- Validation — email regex, password minimum 6 characters, username alphanumeric + underscores, 3–20 characters.
- `BlocConsumer` — per screen; each screen only reacts to its own relevant states.
- Loading UX — full-screen overlay, not dismissible mid-request via `PopScope`.
- Error UX — `SnackBar` with human-readable message mapped from `Failure` type.
- Edit Profile save button — enabled only when username differs from current value.

---

## Phase 6 — Routing & cold-start auth check

Wire auth state into `go_router`.

**Decisions to make:**
- Do you use a `redirect` callback driven by `refreshListenable`, or guard each route individually? (Redirect is cleaner.)
- What's shown during `AuthInitial` / `AuthLoading` on cold start — a splash screen, a blank scaffold, or stay on the previous route?
- Login success: does the bloc navigate, or does the redirect react to state change and push the user automatically?
- Where does the user open Edit Profile from? (AppBar avatar on Home? Drawer? Settings screen?) → this is `context.push('/profile')`, not a redirect target.
- After logout, do you `go('/login')` or let the redirect handle it?

**My answers:**
- Single redirect callback, not per-route guards.
- `GoRouterRefreshStream` adapter connects `AuthBloc.stream` to `refreshListenable`.
- Cold start shows a splash screen during `AuthInitial` / `AuthLoading`.
- Login/logout navigation driven entirely by redirect reacting to state.
- Edit Profile opened via `context.push('/profile')` — back button returns to Home.

```dart
redirect: (context, state) {
  final authState = sl<AuthBloc>().state;
  if (authState is AuthInitial || authState is AuthLoading) return '/splash';
  if (authState is AuthUnauthenticated) return '/login';
  if (authState is AuthAuthenticated) return '/home';
  return null;
}
```

> **Caveat to revisit:** the last line forces every authenticated route back to `/home` — including `/profile`, `/cart`, etc. The redirect needs to check `state.matchedLocation` and only force `/home` when the user is currently on an auth-only route (`/login`, `/register`, `/splash`); otherwise return `null`.

---

## Phase 7 — Replace the random username in chat

Kill the Week 3 placeholder.

**Decisions to make:**
- Who supplies the username to the chat bloc now — passed in at construction, read from `AuthBloc` at send time, or injected via a use case?
- What happens if a user somehow reaches chat while unauthenticated? (Shouldn't happen with the redirect, but decide the contract.)
- Do you delete `GetOrGenerateUsernameUseCase`, or leave it? (Only delete if truly orphaned.)

**My answers:**
- Username injected into `ChatBloc` at construction from `AuthBloc` state in service locator — blocs don't communicate directly.
- If `ChatBloc` is somehow constructed without an authenticated user — assert in debug mode, fail loudly.
- `GetOrGenerateUsernameUseCase` deleted — fully orphaned.

> **Caveat to revisit:** injecting the username at construction means an Edit Profile change won't reach an already-built `ChatBloc`. Either rebuild `ChatBloc` on `AuthAuthenticated` changes, or have it read the current username from `AuthBloc.state` at send time.

---

## Phase 8 — Bonuses

Tackle one at a time, after the core works.

- **Logout button** in Edit Profile.
- **Profile picture** from `photoURL` (decide fallback when null — initials, default icon, gravatar?).
- **Google Sign-In** — adds a new repository method, new use case, new event. Same `Either<Failure, AppUser>` contract.

**My answers:**
- Logout button — in Edit Profile AppBar, fires `LogoutRequested` event.
- Profile picture — `photoUrl` stays nullable; UI shows default `Icons.person` when null. Future upload goes to Firebase Storage, URL saved via `updateProfile`.
- Google Sign-In — skipped for now; same `Either<Failure, AppUser>` contract when revisited.

---

## Profile navigation — the short answer

Profile is **not** a redirect target. It's reached by an explicit user action (e.g. avatar button in the Home AppBar) via `context.push('/profile')` so the back button returns to Home.

Login / Register / Logout transitions, on the other hand, are driven by the `go_router` `redirect` callback reacting to `AuthState` — the bloc doesn't navigate directly.
