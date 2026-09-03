import 'package:dio/dio.dart';
import '../services/token_storage.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
  }) {
    final dio =
        Dio(
            BaseOptions(
              baseUrl: baseUrl,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          )
          ..interceptors.add(_AuthInterceptor(tokenStorage))
          ..interceptors.add(_JsonBodyInterceptor());
    return DioClient._(dio);
  }
}

class _JsonBodyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.data != null &&
        options.data is! Map &&
        options.data is! List &&
        options.data is! String &&
        options.data is! FormData) {
      try {
        options.data = (options.data as dynamic).toJson();
      } catch (_) {}
    }
    handler.next(options);
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  _AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    return handler.next(options);
  }
}
