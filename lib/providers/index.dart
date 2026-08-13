import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/index.dart';
import '../services/dio_client.dart';

// DioClient provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(secureStorage: const FlutterSecureStorage());
});

// Auth state
class AuthState {
  final bool isLoggedIn;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.isLoggedIn = false,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    User? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final DioClient _dioClient;

  AuthNotifier(this._dioClient) : super(AuthState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _dioClient.register(
        name: name,
        email: email,
        password: password,
      );
      state = state.copyWith(
        isLoggedIn: true,
        user: response.user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _dioClient.login(email: email, password: password);
      state = state.copyWith(
        isLoggedIn: true,
        user: response.user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    await _dioClient.logout();
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthNotifier(dioClient);
});

// Packages providers
final packagesProvider = FutureProvider<List<Package>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.getPackages();
});

final packageDetailsProvider = FutureProvider.family<Package, int>((
  ref,
  packageId,
) async {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.getPackageDetails(packageId);
});

// Wishlist providers
final wishlistProvider = FutureProvider<List<Package>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.getWishlist();
});

final toggleWishlistProvider = FutureProvider.family<Map<String, dynamic>, int>(
  (ref, packageId) async {
    final dioClient = ref.watch(dioClientProvider);
    return dioClient.toggleWishlist(packageId);
  },
);

// Availability provider
final availabilityProvider =
    FutureProvider.family<List<Availability>, ({int month, int year})>((
      ref,
      params,
    ) async {
      final dioClient = ref.watch(dioClientProvider);
      return dioClient.getAvailability(month: params.month, year: params.year);
    });

// Bookings provider
final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final dioClient = ref.watch(dioClientProvider);
  return dioClient.getBookings();
});

// Booking form state
class BookingFormState {
  final Package? selectedPackage;
  final DateTime? selectedDate;
  final int? selectedPax;
  final List<int> selectedScentIds;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? venueAddress;
  final String? paymentMethod;
  final bool isLoading;
  final String? errorMessage;

  BookingFormState({
    this.selectedPackage,
    this.selectedDate,
    this.selectedPax,
    this.selectedScentIds = const [],
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.venueAddress,
    this.paymentMethod,
    this.isLoading = false,
    this.errorMessage,
  });

  BookingFormState copyWith({
    Package? selectedPackage,
    DateTime? selectedDate,
    int? selectedPax,
    List<int>? selectedScentIds,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? venueAddress,
    String? paymentMethod,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BookingFormState(
      selectedPackage: selectedPackage ?? this.selectedPackage,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedPax: selectedPax ?? this.selectedPax,
      selectedScentIds: selectedScentIds ?? this.selectedScentIds,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      venueAddress: venueAddress ?? this.venueAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BookingFormNotifier extends StateNotifier<BookingFormState> {
  final DioClient _dioClient;

  BookingFormNotifier(this._dioClient) : super(BookingFormState());

  void setSelectedPackage(Package package) {
    state = state.copyWith(selectedPackage: package);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setSelectedPax(int pax) {
    state = state.copyWith(selectedPax: pax);
  }

  void toggleScent(int scentId) {
    final scents = List<int>.from(state.selectedScentIds);
    if (scents.contains(scentId)) {
      scents.remove(scentId);
    } else {
      scents.add(scentId);
    }
    state = state.copyWith(selectedScentIds: scents);
  }

  void setCustomerName(String name) {
    state = state.copyWith(customerName: name);
  }

  void setCustomerEmail(String email) {
    state = state.copyWith(customerEmail: email);
  }

  void setCustomerPhone(String phone) {
    state = state.copyWith(customerPhone: phone);
  }

  void setVenueAddress(String address) {
    state = state.copyWith(venueAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  Future<Booking?> submitBooking() async {
    if (state.selectedPackage == null ||
        state.selectedDate == null ||
        state.selectedPax == null ||
        state.customerName == null ||
        state.venueAddress == null ||
        state.paymentMethod == null) {
      state = state.copyWith(
        errorMessage: 'Please fill in all required fields',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final booking = await _dioClient.createBooking(
        package_id: state.selectedPackage!.id,
        customer_name: state.customerName!,
        customer_email: state.customerEmail,
        customer_phone: state.customerPhone,
        pax: state.selectedPax,
        event_date:
            '${state.selectedDate!.year}-${state.selectedDate!.month.toString().padLeft(2, '0')}-${state.selectedDate!.day.toString().padLeft(2, '0')}',
        event_time: null,
        venue_address: state.venueAddress!,
        payment_method: state.paymentMethod!,
        scent_ids: state.selectedScentIds.isNotEmpty
            ? state.selectedScentIds
            : null,
      );
      state = state.copyWith(isLoading: false);
      return booking;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  void reset() {
    state = BookingFormState();
  }
}

final bookingFormProvider =
    StateNotifierProvider<BookingFormNotifier, BookingFormState>((ref) {
      final dioClient = ref.watch(dioClientProvider);
      return BookingFormNotifier(dioClient);
    });
