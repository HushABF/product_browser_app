# Product Browser App

A Flutter e-commerce product browser with real-time chat, built with clean architecture.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-FF6B35?style=for-the-badge&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

## About

Product Browser App is a Flutter e-commerce app where users can browse products by category,
manage a shopping cart, and chat about items in real time using Firebase.

I built this to go beyond tutorials — applying clean architecture, BLoC state management,
and Firebase in a real multi-feature app rather than isolated examples.

Every architectural decision in this project has a reason behind it, from why `ChatBloc`
is a Factory instead of a Singleton, to why the domain layer has zero Flutter imports.

## Screenshots

<table>
  <tr>
    <td><img src="https://i.ibb.co/fYgrLbGr/Screenshot-1779175632.png" width="200"/></td>
    <td><img src="https://i.ibb.co/x8H0C49C/Screenshot-1779175644.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Categories Home</td>
    <td align="center">Category's Product</td>
  </tr>
  <tr>
    <td><img src="https://i.ibb.co/yc0m4XCM/Screenshot-1779175650.png" width="200"/></td>
    <td><img src="https://i.ibb.co/nshRj6mP/Screenshot-1779175658.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Product Detail</td>
    <td align="center">Product's Chat</td>
  </tr>
  <tr>
    <td><img src="https://i.ibb.co/nNZLzkPk/Screenshot-1779175670.png" width="200"/></td>
    <td><img src="https://i.ibb.co/pjys8pv5/Screenshot-1779175767.png" width="200"/></td>
  </tr>
  <tr>
    <td align="center">Cart</td>
    <td align="center">Login</td>
  </tr>
  <tr>
    <td><img src="https://i.ibb.co/bRFgG2PJ/Screenshot-1779175798.png" width="200"/></td>
    <td></td>
  </tr>
  <tr>
    <td align="center">Edit Profile</td>
    <td></td>
  </tr>
</table>


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

| Layer | Technology | Why |
|---|---|---|
| UI | Flutter, Material 3 | Cross-platform with a single codebase and a mature design system |
| State management | BLoC / Cubit | Predictable state with clear separation between events and UI |
| Dependency injection | GetIt | Lightweight service locator that works without code generation |
| Navigation | GoRouter | Declarative routing with deep link and redirect support |
| Backend | Firebase Firestore | Real-time data sync without managing a backend server |
| Local storage | SharedPreferences | Simple key-value persistence for lightweight data like usernames |
| HTTP client | Dio | Interceptors and error handling out of the box for REST calls |
| Image caching | CachedNetworkImage | Avoids re-fetching images on every rebuild |


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
2. Set up a Firebase project, then generate the required config files by running:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This generates `lib/firebase_options.dart` and the platform-specific files
   (`android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`, etc.).
   These files are excluded from the repo — see `lib/firebase_options.dart.example` for the expected structure.
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

Currently, `ChatRepositoryImpl` talks directly to Firestore — so it would need to change
along with `MessageModel.fromFirestore()`. Everything above (domain entities, use cases,
abstract repositories, BLoC, and all UI) stays untouched because they depend only on the
abstract `ChatRepository`, never on Firestore directly.

The next architectural improvement would be introducing a `ChatDataSource` abstraction
between the repository impl and Firestore. That way the repository impl handles mapping
and error wrapping (and never changes), and only the data source is swapped when the
backend changes.

**Why is `ChatBloc` registered as `Factory` in GetIt but the repository as `LazySingleton`?**

The repository holds no per-screen state — one instance shared across the app is correct. `ChatBloc` however holds state that is specific to a single product's chat session (`_currentUser`, the stream subscription, the loaded messages). If it were a singleton, opening two different product chats would share the same state and the same stream. `Factory` creates a fresh instance each time `ChatScreen` requests one, so each chat screen gets its own isolated bloc. `CartCubit` is a `LazySingleton` for the opposite reason — the cart is global and must be the same instance everywhere.

**The use cases here just pass calls through. When would they actually add value?**

Right now they are thin wrappers, but they exist for cases that will grow. For example, `SendMessageUseCase` is the right place to enforce the 500-character limit in the domain layer rather than relying solely on the UI guard or Firestore rules. `GetOlderMessagesUseCase` could later validate the `before` cursor or enforce a max page size. Use cases also make it straightforward to combine multiple repository calls in one operation without that logic leaking into the BLoC or the UI.


## Roadmap

- Fix cart persistence — currently saved locally per device, not per user account
- Add Supabase for profile picture uploads as a free backend storage solution
- Add Hero transitions between product grid and detail screen, and shimmer loading placeholders
- Add structured logging across layers for easier debugging
- Expand test coverage across features, starting with use cases and cubits
- Add offline support so users can browse previously loaded products without a connection
