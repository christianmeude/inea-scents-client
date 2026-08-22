# Quick Start Guide - INEA Scents Mobile App

## ⚡ Get Up and Running in 5 Minutes

### Step 1: Clean and Prepare (1 minute)
```bash
cd inea_scents_client
flutter clean
flutter pub get
```

### Step 2: Generate Code (2 minutes)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**What this does:** Generates Freezed immutable classes and JSON serialization code for all data models.

### Step 3: Run the App (2 minutes)
```bash
flutter run
```

Choose your device when prompted (Chrome for web, Android emulator, iOS simulator, etc.)

## 📱 What You'll See

1. **Splash Screen** (3 seconds) - INEA Scents logo
2. **Login Screen** - Enter email and password
3. **Home Screen** - Featured packages and popular items
4. **Full Navigation** - Use bottom nav to explore all features

## 🧪 Test Account (Optional)

If you want to test with an existing account, you'll need credentials created on the backend at https://inea-scents.onrender.com

Or create a new account by:
1. Tapping "Don't have account? Register" on login screen
2. Filling in name, email, password
3. Successfully logging in

## 📂 Project Files Created

All code is organized in `lib/` folder:

```
lib/main.dart                 # Entry point
lib/config/router.dart        # Routes (9 screens)
lib/models/                   # Data classes (5 models)
lib/services/dio_client.dart  # API client
lib/providers/index.dart      # State management (8 providers)
lib/screens/                  # All 9 UI screens
lib/widgets/                  # Reusable components
```

## 🔑 Key Implementation Details

### Authentication
- Uses Bearer tokens (stored securely)
- Automatically added to all API requests
- Token refresh handled on 401 errors

### State Management
- Riverpod for reactive state
- FutureProvider for async data
- StateNotifier for auth and booking forms

### Navigation
- Go Router with 9 named routes
- Deep linking support
- Auth-based route guards

### Database Models
- Freezed + JSON Serializable
- Type-safe API responses
- Automatic code generation

## ✅ Verification Checklist

After running `flutter run`:

- [ ] App launches without errors
- [ ] Splash screen appears for 3 seconds
- [ ] Login screen loads
- [ ] Can tap to navigate to register
- [ ] Bottom nav bar visible on home screen
- [ ] Package list loads
- [ ] Can tap on packages to view details
- [ ] Booking flow shows all 5 steps

## 🆘 If Something Goes Wrong

### Build Errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload Issues
```bash
# Stop the app and run again
flutter run --no-fast-start
```

### Dependency Conflicts
```bash
flutter pub upgrade
```

### Cache Issues
```bash
rm -rf .dart_tool build/  # On Mac/Linux
rmdir /s .dart_tool build  # On Windows
flutter pub get
flutter pub run build_runner build
```

## 🎯 Next Actions

1. **Test Login/Register** - Verify authentication works
2. **Browse Packages** - Check if package list loads
3. **Complete Booking** - Test the full booking flow
4. **Check Bookings** - Verify bookings were created

## 📞 API Connection

The app connects to: `https://inea-scents.onrender.com/api`

All endpoints are implemented in `lib/services/dio_client.dart`

## 🎨 UI Preview

The app includes:
- ✅ Splash screen with logo
- ✅ Login/Register screens
- ✅ Home with featured banner
- ✅ Package grid with search
- ✅ Package details with gallery
- ✅ 5-step booking form with calendar
- ✅ My bookings list
- ✅ User profile and wishlist
- ✅ Bottom navigation bar

---

**Ready to build? Run:** `flutter run`
