import 'package:dio/dio.dart';
import '../services/token_storage.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  factory DioClient({required String baseUrl, required TokenStorage tokenStorage}) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl))..interceptors.add(_AuthInterceptor(tokenStorage));
    return DioClient._(dio);
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  _AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _tokenStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    return handler.next(options);
  }
}
