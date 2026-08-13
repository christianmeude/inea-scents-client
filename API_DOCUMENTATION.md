# API Integration Documentation

## Backend API Specification

**Base URL:** `https://inea-scents.onrender.com/api`

**Authentication:** Bearer Token (stored in `flutter_secure_storage`)

## 🔐 Authentication Endpoints

### Register
```
POST /register
Body: {
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
Response: AuthResponse {
  access_token: string,
  token_type: "Bearer",
  user: { id, name, email }
}
```

### Login
```
POST /login
Body: {
  "email": "john@example.com",
  "password": "password123"
}
Response: AuthResponse {
  access_token: string,
  token_type: "Bearer",
  user: { id, name, email }
}
```

### Logout
```
POST /logout
Headers: { Authorization: "Bearer <token>" }
Response: { message: "Logged out successfully" }
```

## 📦 Package Endpoints

### List All Packages
```
GET /packages
Response: List<Package>
```

**Package Model:**
```dart
{
  id: int,
  name: string,
  description: string,
  price: double,
  rating: double (0-5),
  reviews_count: int,
  images: List<string> (URLs),
  gallery_images: List<string> (URLs),
  pax_options: List<int> ([2, 4, 6, 8]),
  inclusions: List<string>,
  freebies: List<string>,
  scents: List<Scent>,
  created_at: string,
  updated_at: string
}
```

### Get Package Details
```
GET /packages/{id}
Response: Package (with full details)
```

## 🗓️ Availability Endpoints

### Get Calendar Availability
```
GET /availability?month=8&year=2024
Response: List<Availability>
```

**Availability Model:**
```dart
{
  date: string (YYYY-MM-DD),
  status: string ("Available" | "Booked")
}
```

## 📅 Booking Endpoints

### Create Booking
```
POST /bookings
Headers: { Authorization: "Bearer <token>" }
Body: {
  package_id: int,
  customer_name: string,
  customer_email: string (optional),
  customer_phone: string (optional),
  event_date: string (YYYY-MM-DD),
  event_time: string (HH:MM, optional),
  venue_address: string (optional),
  pax: int,
  payment_method: string ("GCash" | "VISA" | "Mastercard" | "Maya"),
  scent_ids: List<int> (selected scents)
}
Response: Booking (with booking_reference)
```

### Get User's Bookings
```
GET /bookings
Headers: { Authorization: "Bearer <token>" }
Response: List<Booking>
```

**Booking Model:**
```dart
{
  id: int,
  booking_reference: string (e.g., "BK123456"),
  user_id: int,
  customer_name: string,
  customer_email: string,
  customer_phone: string,
  pax: int,
  status: string ("Pending" | "Confirmed" | "Cancelled" | "Completed"),
  event_date: string (YYYY-MM-DD),
  event_time: string,
  venue_address: string,
  payment_method: string,
  package: Package (full package details),
  scents: List<Scent> (selected scents),
  created_at: string,
  updated_at: string
}
```

## ❤️ Wishlist Endpoints

### Get Wishlist
```
GET /wishlist
Headers: { Authorization: "Bearer <token>" }
Response: List<Package>
```

### Toggle Package in Wishlist
```
POST /wishlist/toggle
Headers: { Authorization: "Bearer <token>" }
Body: { package_id: int }
Response: { added: boolean }
```

## 🔍 Scent Model

```dart
{
  id: int,
  name: string,
  description: string,
  image_url: string,
  is_available: boolean,
  created_at: string,
  updated_at: string
}
```

## 🛠️ Implementation in App

### DioClient Service
All API calls are implemented in `lib/services/dio_client.dart`:

```dart
// Authentication
await dioClient.register(name, email, password)
await dioClient.login(email, password)
await dioClient.logout()

// Packages
await dioClient.getPackages()
await dioClient.getPackageDetails(packageId)

// Availability
await dioClient.getAvailability(month, year)

// Bookings
await dioClient.createBooking(bookingPayload)
await dioClient.getBookings()

// Wishlist
await dioClient.getWishlist()
await dioClient.toggleWishlist(packageId)
```

### Error Handling
The DioClient provides:
- User-friendly error messages
- Automatic token refresh on 401
- Timeout handling (30 seconds default)
- Request/response logging in dev

### Riverpod Providers
State management providers in `lib/providers/index.dart`:

```dart
// Auth state
authProvider → AuthNotifier → AuthState {
  isLoggedIn, user, errorMessage, isLoading
}

// Async data providers
packagesProvider → FutureProvider<List<Package>>
packageDetailsProvider → FutureProvider.family<Package, int>
bookingsProvider → FutureProvider<List<Booking>>
wishlistProvider → FutureProvider<List<Package>>
availabilityProvider → FutureProvider.family<List<Availability>, ({int month, int year})>

// Form state
bookingFormProvider → BookingFormNotifier → BookingFormState {
  selectedPackage, selectedDate, selectedPax, selectedScentIds,
  customerName, customerEmail, customerPhone, venueAddress,
  paymentMethod, isLoading, errorMessage
}
```

## 🔒 Security Considerations

1. **Token Storage** - Uses `flutter_secure_storage` (encrypted)
2. **HTTPS Only** - All API calls use HTTPS
3. **Bearer Token** - Automatically added to requests via interceptor
4. **Token Expiration** - Handled by redirecting to login on 401
5. **No Hardcoding** - Tokens never stored in code

## 📊 Response Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request (validation errors) |
| 401 | Unauthorized (token invalid/expired) |
| 404 | Not Found |
| 500 | Server Error |

## 🧪 Testing API Calls

### Using Postman/Insomnia
1. Create collection for `https://inea-scents.onrender.com/api`
2. Set up environment variable for `{{token}}`
3. After login, copy token and set environment variable
4. Make subsequent requests with Bearer token

### Example Login Request
```
POST https://inea-scents.onrender.com/api/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "password123"
}
```

### Example Booking Request
```
POST https://inea-scents.onrender.com/api/bookings
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "package_id": 1,
  "customer_name": "John Doe",
  "customer_email": "john@example.com",
  "customer_phone": "09171234567",
  "event_date": "2024-08-15",
  "venue_address": "BGC, Taguig",
  "pax": 4,
  "payment_method": "GCash",
  "scent_ids": [1, 2, 3]
}
```

---

**All endpoints are fully integrated in the Flutter app!**
