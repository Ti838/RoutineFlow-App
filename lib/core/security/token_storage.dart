import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app/constants/app_keys.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _storage.write(key: AppKeys.authToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: AppKeys.refreshToken, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppKeys.authToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: AppKeys.authToken);
    await _storage.delete(key: AppKeys.refreshToken);
  }
}
