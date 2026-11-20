# FlatFit 🏠

**Compatibility-first flatmate matching for India.**

FlatFit helps people in Indian cities find compatible flatmates through a lifestyle-questionnaire-driven matching engine, verified profiles, and in-app tools for living together.

## Tech Stack

- **Flutter** 3.x with Dart 3.x
- **State Management:** Riverpod 2.x
- **Routing:** go_router
- **Backend:** Supabase (Auth, Database, Storage, Edge Functions)
- **Maps:** Google Maps Flutter
- **Payments:** Razorpay (UPI, cards)

## Getting Started

1. Copy `.env.example` to `.env` and fill in your keys.
2. Run:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run
   ```

## Architecture

```
lib/
├── main.dart          # Entry point
├── app.dart           # MaterialApp.router
├── config/            # Theme, routes, l10n, env config
├── core/              # DI, networking, storage, utils, shared widgets, services, models
└── features/          # Feature modules (auth, onboarding, matching, chat, etc.)
    └── <feature>/
        ├── data/          # Repositories & data sources
        ├── domain/        # Models & state
        └── presentation/  # Providers & screens
```

Each feature follows **data → domain → presentation** layering with Riverpod for DI and state.

## Modules

| # | Module | Status |
|---|--------|--------|
| 1 | Auth (Phone OTP, Google) | ✅ |
| 2 | Onboarding & Profile | 🔲 |
| 3 | Questionnaire & Matching | 🔲 |
| 4 | Discovery & Search | 🔲 |
| 5 | Chat & Messaging | 🔲 |
| 6 | Listings | 🔲 |
| 7 | Verification & Trust | 🔲 |
| 8 | Agreements | 🔲 |
| 9 | Living Together | 🔲 |
| 10 | Payments | 🔲 |
| 11 | Services Marketplace | 🔲 |
| 12 | Community | 🔲 |

## License

Proprietary — All rights reserved.
