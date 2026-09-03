import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:inea_scents_client/api/rest_client.dart';

/// In-memory fake backend used by widget tests to avoid real network I/O.
class FakeApiBackend {
  /// Status the POST /api/bookings handler returns for the created booking.
  String bookingStatusAfterCreate = 'pending';

  /// Status returned when the poller hits GET /api/bookings.
  String nextBookingStatus = 'confirmed';

  /// Number of times GET /api/bookings must be polled before returning
  /// [nextBookingStatus]. Lets tests observe the "processing" screen while
  /// the poll is still running.
  int pollAttemptsToResolve = 0;

  /// Number of GET /api/bookings calls made so far.
  int bookingsEndpointCallCount = 0;

  /// When non-null, the created booking carries this checkout URL.
  String? checkoutUrl = 'https://example.com/checkout/IN-2026-000123';

  /// When true, POST /api/bookings answers with an HTTP 500.
  bool failCreateBooking = false;

  /// A single date for the given month/year marked as booked, or null.
  DateTime? bookedDate;

  int get _id => 999;
  String get _reference => 'IN-2026-000123';

  Map<String, Object?> bookingJson({required String status}) => {
    'id': _id,
    'booking_reference': _reference,
    'user_id': 1,
    'customer_name': 'Maria Clara',
    'customer_email': 'maria@example.com',
    'customer_phone': '+639171234567',
    'pax': 50,
    'event_date': '2026-09-01T02:00:00.000Z',
    'event_time': '14:00:00',
    'venue_address': 'The Peninsula Manila',
    'payment_method': 'credit_card',
    'status': status,
    if (checkoutUrl != null) 'checkout_url': checkoutUrl,
  };
}

/// A [Dio] [HttpClientAdapter] that replays canned responses for the two
/// booking endpoints plus availability. All other routes answer 404.
class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.backend);

  final FakeApiBackend backend;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.uri.path;
    final method = options.method.toUpperCase();

    if (path == '/api/availability') {
      final month = options.queryParameters['month'];
      final year = options.queryParameters['year'];
      final booked = backend.bookedDate;
      if (booked != null &&
          month != null &&
          year != null &&
          '${booked.year}' == year.toString() &&
          ('${booked.month}' == month.toString() ||
              '${booked.month}'.padLeft(2, '0') == month.toString())) {
        final day = booked.day.toString().padLeft(2, '0');
        final m = booked.month.toString().padLeft(2, '0');
        return _json(
          '[{"date": "${booked.year}-$m-$day", "status": "Booked"}]',
        );
      }
      return _json('[]');
    }

    if (method == 'POST' && path == '/api/bookings') {
      if (backend.failCreateBooking) {
        return _status(500, '{"detail":"payment provider unavailable"}');
      }
      return _json(
        jsonEncode({
          'data': backend.bookingJson(status: backend.bookingStatusAfterCreate),
        }),
      );
    }

    if (method == 'GET' && path == '/api/bookings') {
      backend.bookingsEndpointCallCount++;
      final resolved =
          backend.bookingsEndpointCallCount > backend.pollAttemptsToResolve;
      return _json(
        jsonEncode({
          'data': [
            backend.bookingJson(
              status: resolved ? backend.nextBookingStatus : 'pending',
            ),
          ],
        }),
      );
    }

    return _status(404, '{"detail":"not found"}');
  }
}

ResponseBody _json(String body) {
  return ResponseBody.fromString(
    body,
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ResponseBody _status(int code, [String? body]) {
  return ResponseBody.fromString(
    body ?? '',
    code,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

RestClient buildFakeRestClient(FakeApiBackend backend) {
  final dio = Dio(BaseOptions(baseUrl: 'http://fake.test'))
    ..httpClientAdapter = FakeHttpClientAdapter(backend);
  return RestClient(dio);
}
