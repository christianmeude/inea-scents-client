import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/token_storage.dart';
import '../network/dio_client.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  // Change to staging base URL or override via environment/config
  const baseUrl = 'https://inea-scents.onrender.com';
  return DioClient(baseUrl: baseUrl, tokenStorage: storage);
});

// NOTE: Generated API client provider should be added after codegen,
// for example: final apiClientProvider = Provider((ref) => ApiClient(ref.read(dioClientProvider).dio));
