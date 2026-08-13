import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/index.dart';

class DioClient {
  static const String baseUrl = 'https://inea-scents.onrender.com/api';
  static const String tokenKey = 'access_token';

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  DioClient({Dio? dio, FlutterSecureStorage? secureStorage})
    : _dio = dio ?? Dio(),
      _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.contentType = 'application/json';

    // Add interceptor for Bearer token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, clear it
            await _clearToken();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    try {
      return await _secureStorage.read(key: tokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      await _secureStorage.write(key: tokenKey, value: token);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _clearToken() async {
    try {
      await _secureStorage.delete(key: tokenKey);
    } catch (e) {
      // Handle error
    }
  }

  // Auth Endpoints
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await _saveToken(authResponse.access_token);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await _saveToken(authResponse.access_token);
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    await _clearToken();
  }

  // Package Endpoints
  Future<List<Package>> getPackages() async {
    try {
      final response = await _dio.get('/packages');
      // Handle both wrapped and unwrapped responses
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Unexpected API response format');
      }
      final packages = data
          .map((item) => Package.fromJson(item as Map<String, dynamic>))
          .toList();
      return packages;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Package> getPackageDetails(int packageId) async {
    try {
      final response = await _dio.get('/packages/$packageId');
      return Package.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Availability Endpoints
  Future<List<Availability>> getAvailability({
    required int month,
    required int year,
  }) async {
    try {
      final response = await _dio.get(
        '/availability',
        queryParameters: {'month': month, 'year': year},
      );
      // Handle both wrapped and unwrapped responses
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Unexpected API response format');
      }
      final availabilities = data
          .map((item) => Availability.fromJson(item as Map<String, dynamic>))
          .toList();
      return availabilities;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Booking Endpoints
  Future<Booking> createBooking({
    required int package_id,
    required String customer_name,
    required String? customer_email,
    required String? customer_phone,
    required int? pax,
    required String event_date,
    required String? event_time,
    required String venue_address,
    required String payment_method,
    required List<int>? scent_ids,
  }) async {
    try {
      final data = {
        'package_id': package_id,
        'customer_name': customer_name,
        'event_date': event_date,
        'venue_address': venue_address,
        'payment_method': payment_method,
      };

      if (customer_email != null) data['customer_email'] = customer_email;
      if (customer_phone != null) data['customer_phone'] = customer_phone;
      if (pax != null) data['pax'] = pax;
      if (event_time != null) data['event_time'] = event_time;
      if (scent_ids != null && scent_ids.isNotEmpty) {
        data['scent_ids'] = scent_ids;
      }

      final response = await _dio.post('/bookings', data: data);
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Booking>> getBookings() async {
    try {
      final response = await _dio.get('/bookings');
      // Handle both wrapped and unwrapped responses
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Unexpected API response format');
      }
      final bookings = data
          .map((item) => Booking.fromJson(item as Map<String, dynamic>))
          .toList();
      return bookings;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Wishlist Endpoints
  Future<List<Package>> getWishlist() async {
    try {
      final response = await _dio.get('/wishlist');
      // Handle both wrapped and unwrapped responses
      List<dynamic> data;
      if (response.data is List) {
        data = response.data as List<dynamic>;
      } else if (response.data is Map && response.data.containsKey('data')) {
        data = response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Unexpected API response format');
      }
      final packages = data
          .map((item) => Package.fromJson(item as Map<String, dynamic>))
          .toList();
      return packages;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> toggleWishlist(int packageId) async {
    try {
      final response = await _dio.post(
        '/wishlist/toggle',
        data: {'package_id': packageId},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException error) {
    if (error.response != null) {
      return error.response?.data['message'] ??
          'API Error: ${error.response?.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. Please try again.';
    } else {
      return 'An error occurred: ${error.message}';
    }
  }
}
