import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';
import '../src/providers/core_providers.dart';
import '../src/services/token_storage.dart';

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
  final RestClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthNotifier(this._apiClient, this._tokenStorage) : super(AuthState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _apiClient.auth.postApiRegister(
        body: ApiRegisterRequestBody(name: name, email: email, password: password)
      );
      if (response.accessToken != null) {
        await _tokenStorage.saveToken(response.accessToken!);
      }
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
      final response = await _apiClient.auth.postApiLogin(
        body: ApiLoginRequestBody(email: email, password: password)
      );
      if (response.accessToken != null) {
        await _tokenStorage.saveToken(response.accessToken!);
      }
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
    await _tokenStorage.deleteToken();
    state = AuthState();
  }

  Future<void> refreshProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _apiClient.auth.getApiUser();
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthNotifier(apiClient, tokenStorage);
});

// Packages providers
final packagesProvider = FutureProvider<List<Package>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.packages.getApiPackages();
  return response.data ?? [];
});

final packageDetailsProvider = FutureProvider.family<Package, int>((
  ref,
  packageId,
) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.packages.getApiPackagesPackage(package: packageId);
  return response.data!;
});

// Wishlist providers
class WishlistNotifier extends AsyncNotifier<List<Package>> {
  @override
  Future<List<Package>> build() async {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.wishlist.getApiWishlist();
    return response.data ?? [];
  }

  Future<void> toggle(int packageId) async {
    final apiClient = ref.read(apiClientProvider);
    await apiClient.wishlist.postApiWishlistToggle(
      body: ApiWishlistToggleRequestBody(packageId: packageId),
    );
    ref.invalidateSelf();
  }
}

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<Package>>(
  WishlistNotifier.new,
);

// Availability provider
class AvailabilityState {
  final int month;
  final int year;
  final List<Availability> data;
  
  AvailabilityState({
    required this.month,
    required this.year,
    required this.data,
  });
}

class AvailabilityNotifier extends AsyncNotifier<AvailabilityState> {
  @override
  Future<AvailabilityState> build() async {
    final now = DateTime.now();
    return _fetch(now.month, now.year);
  }

  Future<AvailabilityState> _fetch(int month, int year) async {
    final apiClient = ref.read(apiClientProvider);
    final response = await apiClient.availability.getApiAvailability(
      month: month,
      year: year,
    );
    return AvailabilityState(month: month, year: year, data: response);
  }

  void nextMonth() async {
    final current = state.value;
    if (current == null) return;
    int nextM = current.month + 1;
    int nextY = current.year;
    if (nextM > 12) {
      nextM = 1;
      nextY++;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(nextM, nextY));
  }

  void previousMonth() async {
    final current = state.value;
    if (current == null) return;
    int prevM = current.month - 1;
    int prevY = current.year;
    if (prevM < 1) {
      prevM = 12;
      prevY--;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(prevM, prevY));
  }

  void setMonth(int month, int year) async {
    final current = state.value;
    if (current != null && current.month == month && current.year == year) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(month, year));
  }

  void refresh() async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(current.month, current.year));
  }
}

final availabilityProvider = AsyncNotifierProvider<AvailabilityNotifier, AvailabilityState>(
  AvailabilityNotifier.new,
);

// Bookings provider
final bookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.bookings.getApiBookings();
  return response.data ?? [];
});

// Booking flow state
class BookingFlowState {
  final Package? selectedPackage;
  final DateTime? selectedDate;
  final String? selectedTime;
  final int? selectedPax;
  final List<int> selectedScentIds;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? venueAddress;
  final String? paymentMethod;
  final bool isLoading;
  final String? errorMessage;
  final int currentStep;

  BookingFlowState({
    this.selectedPackage,
    this.selectedDate,
    this.selectedTime,
    this.selectedPax,
    this.selectedScentIds = const [],
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.venueAddress,
    this.paymentMethod,
    this.isLoading = false,
    this.errorMessage,
    this.currentStep = 0,
  });

  double get totalPrice {
    return (selectedPackage?.price ?? 0) + 800 + 1500;
  }

  BookingFlowState copyWith({
    Package? selectedPackage,
    DateTime? selectedDate,
    String? selectedTime,
    int? selectedPax,
    List<int>? selectedScentIds,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? venueAddress,
    String? paymentMethod,
    bool? isLoading,
    String? errorMessage,
    int? currentStep,
  }) {
    return BookingFlowState(
      selectedPackage: selectedPackage ?? this.selectedPackage,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedPax: selectedPax ?? this.selectedPax,
      selectedScentIds: selectedScentIds ?? this.selectedScentIds,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      venueAddress: venueAddress ?? this.venueAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  final RestClient _apiClient;

  BookingFlowNotifier(this._apiClient) : super(BookingFlowState());

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setSelectedPackage(Package package) {
    int? defaultPax = 1;
    if (package.paxOptions != null && package.paxOptions!.isNotEmpty) {
      if (!package.paxOptions!.contains(1)) {
        defaultPax = package.paxOptions!.first;
      }
    }
    state = state.copyWith(selectedPackage: package, selectedPax: defaultPax);
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setSelectedTime(String time) {
    state = state.copyWith(selectedTime: time);
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

  Future<dynamic> submitBooking() async {
    if (state.selectedPackage == null ||
        state.selectedDate == null ||
        state.selectedTime == null ||
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
      final booking = await _apiClient.bookings.postApiBookings(
        body: ApiBookingsRequestBody(
          packageId: state.selectedPackage!.id!,
          customerName: state.customerName!,
          customerEmail: state.customerEmail ?? '',
          customerPhone: state.customerPhone,
          pax: state.selectedPax ?? 0,
          eventDate: state.selectedDate!,
          eventTime: state.selectedTime,
          venueAddress: state.venueAddress!,
          paymentMethod: PaymentMethod.fromJson(state.paymentMethod!),
          scentIds: state.selectedScentIds.isNotEmpty
              ? state.selectedScentIds
              : null,
        )
      );
      state = state.copyWith(isLoading: false);
      return booking;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }

  void reset() {
    state = BookingFlowState();
  }
}

final bookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return BookingFlowNotifier(apiClient);
    });
