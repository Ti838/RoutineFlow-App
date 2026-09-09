import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/security/token_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepositoryImpl(tokenStorage: tokenStorage);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthInitial()) {
    checkStatus();
  }

  Future<void> checkStatus() async {
    state = AuthLoading();
    try {
      final user = await _repository.checkAuthStatus();
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = Unauthenticated();
      }
    } catch (e) {
      state = Unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _repository.login(email: email, password: password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = AuthLoading();
    try {
      final user = await _repository.register(name: name, email: email, password: password);
      state = Authenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = Unauthenticated();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});
