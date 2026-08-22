import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/token_storage.dart';
import '../network/dio_client.dart';
import '../../api/rest_client.dart';

import '../../config/environment.dart';

String _getLocalBackendUrl() {
  if (kIsWeb) {
    return 'http://127.0.0.1:8000';
  }
  // Android Emulator uses 10.0.2.2 to access the host machine's localhost
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  
  String baseUrl;
  
  if (kIsWeb && !kDebugMode) {
    // When served by Laravel in production, use a relative path
    baseUrl = '';
  } else if (!kDebugMode) {
    // Release builds on mobile/desktop ALWAYS use the live backend
    baseUrl = 'https://inea-scents.onrender.com';
  } else {
    // Debug builds check the manual toggle
    baseUrl = currentEnvironment == Environment.local 
        ? _getLocalBackendUrl() 
        : 'https://inea-scents.onrender.com';
  }
      
  return DioClient(baseUrl: baseUrl, tokenStorage: storage);
});

// Generated API client provider
final apiClientProvider = Provider<RestClient>((ref) {
  return RestClient(ref.read(dioClientProvider).dio);
});
