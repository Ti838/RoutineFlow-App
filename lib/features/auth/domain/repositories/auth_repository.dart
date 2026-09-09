import '../../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> checkAuthStatus();
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({required String name, required String email, required String password});
  Future<void> logout();
  Future<void> forgotPassword(String email);
}
