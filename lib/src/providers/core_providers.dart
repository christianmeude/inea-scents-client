import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/token_storage.dart';
import '../network/dio_client.dart';
import '../../api/rest_client.dart';

/// 12-Factor: API_URL is required at build time via --dart-define.
/// No hardcoded fallbacks. Each Vercel env (Preview/Production) and each
/// `flutter run` must pass its backend explicitly.
///
/// Examples:
///  - local web:   flutter run -d chrome --dart-define=API_URL=http://127.0.0.1:8080
///  - local android emulator: --dart-define=API_URL=http://10.0.2.2:8080
///  - prod web:    --dart-define=API_URL=https://ineascents.onrender.com

String _getLocalFallbackForPlatform() {
  if (kIsWeb) return 'http://127.0.0.1:8080';
  if (Platform.isAndroid) return 'http://10.0.2.2:8080';
  return 'http://127.0.0.1:8080';
}

String _resolveBaseUrl() {
  const apiUrl = String.fromEnvironment('API_URL');

  // In DEBUG without a dart-define, fall back to platform-local backend
  // for convenience. In RELEASE, API_URL is required — misconfig fails fast.
  if (apiUrl.isEmpty) {
    const isRelease = bool.fromEnvironment('dart.vm.product');
    if (isRelease) {
      throw StateError(
        'API_URL dart-define is required for release builds. '
        'Build with --dart-define=API_URL=https://ineascents.onrender.com (prod).',
      );
    }
    return _getLocalFallbackForPlatform();
  }
  return apiUrl;
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  final baseUrl = _resolveBaseUrl();
  return DioClient(baseUrl: baseUrl, tokenStorage: storage);
});

// Generated API client provider
final apiClientProvider = Provider<RestClient>((ref) {
  return RestClient(ref.read(dioClientProvider).dio);
});
