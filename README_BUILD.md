# 🎉 INEA Scents - Flutter Mobile Application

> A complete, production-ready Flutter mobile app for INEA Scents perfume bar booking platform

## ⚡ Quick Start (2 minutes)

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (freezed + json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

**That's it!** The app will launch on your device/emulator. See [QUICK_START.md](QUICK_START.md) for more details.

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - 5-minute setup guide (START HERE!)
- **[DELIVERY_SUMMARY.md](DELIVERY_SUMMARY.md)** - Complete project overview
- **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)** - Architecture and features
- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - All API endpoints
- **[FILE_INVENTORY.md](FILE_INVENTORY.md)** - Complete file listing

## 🎯 What's Included

✅ **9 Screens** - Complete UI matching Figma designs
- Splash, Login, Register, Home, Packages, Package Details, Booking (5 steps), My Bookings, Profile

✅ **10 API Endpoints** - Full backend integration
- Authentication, Packages, Bookings, Calendar, Wishlist

✅ **State Management** - Riverpod with 8 providers
- Auth, Packages, Bookings, Wishlist, Booking Form

✅ **Routing** - Go Router with 9 named routes
- Deep linking support, route guards

✅ **Security** - JWT token management
- Flutter Secure Storage, Bearer token interceptor

✅ **Data Models** - 5 Freezed models
- Type-safe, JSON serializable, immutable

## 🏗️ Architecture

```
Models → Services → Providers → Screens → Widgets
  ↓         ↓          ↓         ↓        ↓
Freezed   DioClient  Riverpod  ConsumerWidget  Reusable
 (5)      (API)      (8)       (9)            (2)
```

## 🔌 Connectivity

**Backend API:** `https://inea-scents.onrender.com/api`

All endpoints are fully integrated:
- POST `/register` - Create account
- POST `/login` - Authenticate
- GET `/packages` - List packages
- POST `/bookings` - Create booking
- GET `/bookings` - Get user bookings
- GET `/wishlist` - Get favorites
- ... and more!

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete reference.

## 📱 Screenshots

The app includes these fully-functional screens:

1. **Splash Screen** - 3-second intro with logo
2. **Login Screen** - Email + password authentication
3. **Register Screen** - New user signup
4. **Home Screen** - Featured packages and popular items
5. **Packages Screen** - Browse all packages with search
6. **Package Details** - Full info with gallery
7. **Booking Flow** (5-step):
   - Select package
   - Choose scents
   - Pick date (calendar) + PAX
   - Enter customer details
   - Select payment method
8. **My Bookings** - View all orders with status
9. **Profile** - User info, wishlist, settings

## 🛠️ Technology Stack

- **Framework**: Flutter 3.12.2+
- **State Management**: flutter_riverpod 2.3.6
- **HTTP Client**: dio 5.3.2
- **Routing**: go_router 7.0.0
- **Data Models**: freezed + json_serializable
- **Storage**: flutter_secure_storage (encrypted)
- **UI Components**: table_calendar

## 🔐 Security

- ✅ JWT tokens stored in encrypted flutter_secure_storage
- ✅ HTTPS-only API calls
- ✅ Bearer token auto-injected in all requests
- ✅ Automatic logout on token expiration
- ✅ No credentials in code

## 📋 Prerequisites

- Flutter 3.12.0 or higher
- Dart 3.0 or higher
- An Android device/emulator OR iOS simulator OR Chrome for web
- Internet connection (to reach backend API)

## ✨ Features

**Authentication**
- User registration and login
- Secure token storage
- Auto-logout on expiration

**Package Browsing**
- List all packages
- View detailed package information
- Gallery with multiple images
- Search functionality

**Booking System**
- Multi-step booking form
- Calendar date selection
- Scent selection
- Customer information
- Payment method selection

**User Management**
- User profile page
- Wishlist management
- Booking history
- Settings (edit profile, logout)

**UI/UX**
- Responsive design
- Error handling
- Loading states
- Beautiful gradient UI
- Bottom navigation bar

## 📊 Project Structure

```
flutter_application_sample/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── config/router.dart        # Navigation setup
│   ├── models/                   # Data classes
│   ├── services/dio_client.dart  # API client
│   ├── providers/                # State management
│   ├── screens/                  # All 9 UI screens
│   └── widgets/                  # Reusable components
├── pubspec.yaml                  # Dependencies
└── [Documentation Files]
```

See [FILE_INVENTORY.md](FILE_INVENTORY.md) for complete file listing.

## 🚀 Getting Started

### 1. First Time Setup

```bash
cd flutter_application_sample
flutter pub get
```

### 2. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `.freezed.dart` files (immutable models)
- `.g.dart` files (JSON serialization)

### 3. Run

```bash
flutter run
```

### 4. Test

1. See splash screen (3 seconds)
2. Login/Register
3. Browse packages
4. Complete booking flow
5. View bookings

## 📚 Documentation Guide

| Document | Best For |
|----------|----------|
| [QUICK_START.md](QUICK_START.md) | Getting the app running fast |
| [DELIVERY_SUMMARY.md](DELIVERY_SUMMARY.md) | Understanding the full project |
| [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) | Learning the architecture |
| [API_DOCUMENTATION.md](API_DOCUMENTATION.md) | Backend integration details |
| [FILE_INVENTORY.md](FILE_INVENTORY.md) | File-by-file breakdown |

## 🐛 Troubleshooting

### Code generation failed?
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Can't connect to API?
- Verify backend is running at `https://inea-scents.onrender.com`
- Check network connectivity
- Look at console logs for Dio errors

### Build failing?
```bash
rm -rf .dart_tool build/
flutter pub get
flutter pub run build_runner build
```

### Need more help?
See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md#-troubleshooting) for detailed troubleshooting.

## 📞 Support

- **Flutter Docs**: https://flutter.dev
- **Riverpod Docs**: https://riverpod.dev
- **Go Router**: https://pub.dev/packages/go_router
- **Backend API**: https://inea-scents.onrender.com/docs

## ✅ Checklist Before Launching

- [ ] Flutter SDK installed and updated
- [ ] `flutter pub get` completed
- [ ] `flutter pub run build_runner build` completed
- [ ] No errors in `flutter analyze`
- [ ] Device/emulator connected
- [ ] Backend API is running
- [ ] Ready to `flutter run`!

## 🎊 You're All Set!

The application is **production-ready** with:

✅ Complete feature set
✅ Full API integration
✅ Proper error handling
✅ Clean architecture
✅ Type-safe code
✅ Secure authentication
✅ Beautiful UI

**Ready to launch?** Run `flutter run` now! 🚀

---

## 📝 Version Info

- **Flutter**: 3.12.2+
- **Build Date**: 2024
- **Status**: Production Ready ✅

---

**Made with ❤️ using Flutter, Riverpod, and Go Router**

Questions? See the documentation files above for detailed information!
