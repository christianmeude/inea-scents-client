# Inea Scents - Mobile Application

> A complete, production-ready Flutter mobile app for the Inea Scents perfume bar booking platform.

## 🌍 The Ecosystem

The Inea Scents platform consists of three separate repositories. This repository relies on the backend for API endpoints:
1. **`inea_scents_client` (This Repo)**: Flutter cross-platform mobile/web application for customer bookings.
2. **`inea-scents`**: Laravel backend, PostgreSQL database, and Admin Dashboard.
3. **`inea-scents-landing`**: React/Vite customer-facing marketing website.

## ⚡ Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (freezed + json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

*Note: Ensure the `inea-scents` backend is running locally or configured to point to the production API, or the app will not be able to fetch data.*

## 📋 Prerequisites

- Flutter 3.12.0 or higher
- Dart 3.0 or higher
- Android Studio / Xcode (depending on target platform)
- Connected device, emulator, or Chrome (for web testing)

## 🛠️ Technology Stack

- **Framework**: Flutter 3.12.2+
- **State Management**: flutter_riverpod 2.3.6
- **HTTP Client**: dio 5.3.2
- **Routing**: go_router 7.0.0
- **Data Models**: freezed + json_serializable
- **Storage**: flutter_secure_storage (encrypted)

## ✨ Features

- **Authentication**: Secure login/registration with encrypted JWT tokens.
- **Package Browsing**: View available perfume packages, search, and browse galleries.
- **Booking Flow**: Multi-step booking process including calendar selection, scent picking, and customer details.
- **User Profile**: Manage bookings, wishlist, and account settings.
- **Offline Resilience**: Clean error handling and loading states.

## 🔌 Connectivity

**Backend API:**
This mobile client connects to the `inea-scents` Laravel backend. By default, it may point to `https://inea-scents.onrender.com/api` or your local development server (`http://127.0.0.1:8000/api`).

All endpoints are fully integrated in `lib/services/dio_client.dart`:
- `POST /register`, `POST /login` (Auth)
- `GET /packages`, `GET /wishlist` (Browsing)
- `POST /bookings`, `GET /bookings` (Orders)

## 📁 Project Structure

```text
lib/
├── main.dart                 # Entry point
├── config/router.dart        # Navigation setup
├── models/                   # Data classes (Freezed)
├── services/dio_client.dart  # API client
├── providers/                # State management (Riverpod)
├── screens/                  # All UI screens (9 total)
└── widgets/                  # Reusable components
```

## 🐛 Troubleshooting

- **Code generation failed?** Run `flutter clean && flutter pub get` before running `build_runner`.
- **Can't connect to API?** Verify the backend repository is running and reachable from your emulator (e.g., use `10.0.2.2` instead of `127.0.0.1` for Android Emulator).
- **Build failing?** Clear cache: `rm -rf .dart_tool build/` then retry fetching dependencies.

---
*Status: Production Ready*
