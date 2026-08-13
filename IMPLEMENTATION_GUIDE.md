# INEA Scents Mobile App - Complete Implementation Guide

This Flutter application is a fully functional mobile app for the INEA Scents perfume bar booking platform. It connects to the backend API deployed at `https://inea-scents.onrender.com` and provides a seamless user experience for browsing packages, making bookings, and managing orders.

## 🚀 Project Structure

```
lib/
├── main.dart                 # Application entry point with Riverpod and routing
├── config/
│   └── router.dart          # Go Router configuration with all routes
├── models/                   # Data models (freezed with json_serializable)
│   ├── auth_response.dart
│   ├── booking.dart
│   ├── package.dart
│   ├── scent.dart
│   ├── availability.dart
│   └── index.dart           # Barrel file
├── providers/                # Riverpod state management
│   └── index.dart           # All providers (auth, packages, bookings, etc.)
├── services/
│   └── dio_client.dart      # Dio HTTP client with auth interceptor
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── packages_screen.dart
│   ├── package_detail_screen.dart
│   ├── booking_screen.dart   # Multi-step booking form
│   ├── my_bookings_screen.dart
│   ├── profile_screen.dart
│   └── index.dart           # Barrel file
└── widgets/                  # Reusable widgets
    ├── package_card.dart
    ├── bottom_nav_bar.dart
    └── index.dart           # Barrel file
```

## 📦 Dependencies

The project uses modern Flutter best practices:

- **Networking**: `dio` (v5.3.2) - HTTP client with interceptors
- **State Management**: `flutter_riverpod` (v2.3.6) - Reactive state management
- **Routing**: `go_router` (v7.0.0) - App routing and navigation
- **Data Classes**: `freezed` + `json_serializable` - Immutable models with JSON serialization
- **Local Storage**: `flutter_secure_storage` (v9.1.0) - Secure token storage
- **Calendar**: `table_calendar` (v3.0.9) - Calendar widget for availability
- **Secure Storage**: Flutter Secure Storage for JWT tokens

## 🔧 Setup Instructions

### 1. Install Dependencies

```bash
cd flutter_application_sample
flutter pub get
```

### 2. Generate Code (Required for Freezed and JSON Serialization)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `.freezed.dart` files for immutable models
- `.g.dart` files for JSON serialization/deserialization

### 3. Run the App

```bash
flutter run
```

Or specify a device:
```bash
flutter run -d chrome    # Web
flutter run -d emulator  # Android emulator
flutter run -d "iPhone 15"  # iOS simulator
```

## 🏗️ Architecture

### Authentication Flow
1. User logs in/registers via login/register screens
2. Backend returns `AuthResponse` with `access_token`
3. Token is stored securely in `flutter_secure_storage`
4. Dio interceptor automatically adds `Authorization: Bearer <token>` to all requests
5. If token expires (401 response), it's cleared and user is logged out

### API Integration

All API calls go through `DioClient` which:
- Handles base URL (`https://inea-scents.onrender.com/api`)
- Manages Bearer token authentication
- Handles errors and timeouts
- Parses responses into strongly-typed models

### State Management with Riverpod

**Providers used:**
- `dioClientProvider` - Singleton Dio client instance
- `authProvider` - Auth state (login, register, logout)
- `packagesProvider` - List of all packages
- `packageDetailsProvider` - Single package details
- `bookingsProvider` - User's bookings
- `bookingFormProvider` - Multi-step booking form state
- `wishlistProvider` - User's wishlist
- `availabilityProvider` - Calendar availability for a month/year

## 📱 Screens Overview

### Splash Screen
- App logo with gradient background
- Navigates to login after 3 seconds

### Authentication
- **Login**: Email + password
- **Register**: Name + email + password
- Secure token storage after successful auth

### Home Screen
- Featured banner ("Make Every Moment Unforgettable")
- Popular packages grid
- Search functionality
- Bottom navigation bar

### Package Details
- Full package information
- Inclusions and freebies
- Gallery of images
- "Book Now" button

### Booking Flow (Multi-Step)
1. **Package** - Confirm package selection
2. **Scents** - Choose preferred scents
3. **Schedule** - Pick date from calendar, select number of PAX
4. **Details** - Enter customer info and venue address
5. **Payment** - Select payment method and review total cost

### My Bookings
- List of all user bookings
- Status indicators (Pending, Confirmed, Cancelled)
- Booking details (date, venue, pax, cost)

### Profile
- User information
- Wishlist section
- Settings (edit profile, change password, help, logout)

## 🔌 API Endpoints

### Authentication
- `POST /register` - Register new user
- `POST /login` - Login user

### Packages
- `GET /api/packages` - List all packages
- `GET /api/packages/{id}` - Package details

### Bookings
- `POST /api/bookings` - Create booking
- `GET /api/bookings` - Get user's bookings

### Availability
- `GET /api/availability?month=8&year=2024` - Calendar availability

### Wishlist
- `GET /api/wishlist` - Get wishlist
- `POST /api/wishlist/toggle` - Toggle package in wishlist

## 🛡️ Security

- Bearer tokens stored in `flutter_secure_storage` (encrypted)
- Tokens automatically added to all API requests
- Automatic logout on token expiration
- All API calls use HTTPS

## 🎨 Theme & Colors

- **Primary**: `#8B6B7C` (purple/mauve) - Used for buttons, headers
- **Secondary**: Gradient backgrounds with grays
- **Accent**: Gold/amber for ratings

## 📋 Data Models

### User
```dart
id, name, email
```

### Package
```dart
id, name, description, price, rating, reviews_count
inclusions[], freebies[], pax_options[]
scents[], images[], gallery_images[]
created_at, updated_at
```

### Scent
```dart
id, name, description, image_url, is_available
created_at, updated_at
```

### Booking
```dart
id, booking_reference, user_id, customer_name
customer_email, customer_phone, pax
event_date, event_time, venue_address
payment_method, status
package, scents[]
```

## 🧪 Testing

To test the app:

1. **Sign Up**: Create a test account
2. **Browse**: View available packages
3. **Book**: Complete the full booking flow
4. **Check Bookings**: View your confirmed bookings in "My Bookings"
5. **Wishlist**: Add packages to wishlist from profile

## 🐛 Troubleshooting

### Code generation errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### API connection errors
- Ensure backend is running at `https://inea-scents.onrender.com`
- Check network connectivity
- Verify auth token is being stored correctly

### Routing issues
- All routes are defined in `lib/config/router.dart`
- Use `context.go('/path')` or `context.push('/path')` for navigation
- Check GoRouter configuration for typos

## 📚 Key Features Implemented

✅ User Authentication (login/register)
✅ Browse Packages
✅ Package Details with Gallery
✅ Multi-Step Booking Flow
✅ Calendar-Based Date Selection
✅ Scent Selection
✅ Wishlist Management
✅ My Bookings Page
✅ User Profile
✅ Secure Token Storage
✅ Error Handling
✅ Loading States
✅ Responsive Design

## 🚀 Next Steps

### Optional Enhancements
- Add image caching for better performance
- Implement search filtering
- Add payment gateway integration
- Push notifications for booking updates
- Review and rating system
- Social sharing of bookings
- Offline support with local cache
- Dark mode theme

## 📞 Support

For API documentation, visit:
- Swagger UI: https://inea-scents.onrender.com/api/documentation
- OpenAPI Spec: https://inea-scents.onrender.com/docs?api-docs.json

---

**Built with Flutter + Riverpod + Go_Router** 🎉
