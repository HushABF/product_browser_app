# Product Browser App

A Flutter e-commerce product browser with real-time chat, built with clean architecture.

## Features

- **Product browsing** — browse products by category with images, prices, and ratings
- **Product detail** — full product view with add/remove from cart
- **Shopping cart** — persistent cart with badge counter
- **Real-time chat** — per-product chat room powered by Firebase Firestore
  - Chat bubbles with sender alignment (mine vs others)
  - Anonymous guest usernames (persisted across sessions)
  - Message count badge on the chat button
  - Paginated messages — loads last 20, fetches older on scroll to top
  - Auto-scroll to bottom when you send a message

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter, Material 3 |
| State management | BLoC / Cubit |
| Dependency injection | GetIt |
| Navigation | GoRouter |
| Backend | Firebase Firestore |
| Local storage | SharedPreferences |
| HTTP client | Dio |
| Image caching | CachedNetworkImage |

## Architecture

Clean architecture with three layers per feature:

```
lib/
├── core/              # Shared widgets, DI, networking
└── features/
    ├── product/       # Product listing and detail
    ├── category/      # Category browsing
    ├── cart/          # Shopping cart
    └── chat/          # Real-time chat
        ├── domain/    # Entities, repositories (abstract), use cases
        ├── data/      # Repository implementations, models
        └── presentation/ # BLoC, Cubits, screens, widgets
```

## Getting Started

1. Clone the repo
2. Set up a Firebase project and add `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
3. Set Firestore rules:
```
match /chats/{productId}/messages/{messageId} {
  allow read: if true;
  allow create: if request.resource.data.text.size() <= 500;
}
```
4. Run:
```bash
flutter pub get
flutter run
```

## Architecture Decisions

**If you swapped Firestore for a different database, which files change and which don't?**

Only the `data/` layer changes. `ChatRepositoryImpl`, `MessageModel`, and `UserRepositoryImpl` would be rewritten for the new database. Everything above — domain entities, use cases, abstract repositories, BLoC, Cubits, and all UI — stays untouched because they depend only on the abstract `ChatRepository`, never on Firestore directly. The domain layer defines the contract; the data layer fulfills it.

**Why is `ChatBloc` registered as `Factory` in GetIt but the repository as `LazySingleton`?**

The repository holds no per-screen state — one instance shared across the app is correct. `ChatBloc` however holds state that is specific to a single product's chat session (`_currentUser`, the stream subscription, the loaded messages). If it were a singleton, opening two different product chats would share the same state and the same stream. `Factory` creates a fresh instance each time `ChatScreen` requests one, so each chat screen gets its own isolated bloc. `CartCubit` is a `LazySingleton` for the opposite reason — the cart is global and must be the same instance everywhere.

**The use cases here just pass calls through. When would they actually add value?**

Right now they are thin wrappers, but they exist for cases that will grow. For example, `SendMessageUseCase` is the right place to enforce the 500-character limit in the domain layer rather than relying solely on the UI guard or Firestore rules. `GetOrGenerateUsernameUsecase` already contains real logic — generating and persisting a UUID. `GetOlderMessagesUseCase` could later validate the `before` cursor or enforce a max page size. Use cases also make it straightforward to combine multiple repository calls in one operation without that logic leaking into the BLoC or the UI.
