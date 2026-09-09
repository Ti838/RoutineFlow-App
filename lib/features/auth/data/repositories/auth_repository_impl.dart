import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/constants/app_keys.dart';
import '../../../../core/security/token_storage.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.tokenStorage});

  @override
  Future<UserModel?> checkAuthStatus() async {
    final token = await tokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      return null;
    }
    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString(AppKeys.userProfile);
    if (userJsonStr != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJsonStr));
      } catch (_) {
        return null;
      }
    }
    return UserModel(
      id: 'user_1',
      name: 'Alex',
      email: 'student@routineflow.app',
      universityName: 'Dhaka University of Engineering & Technology',
      department: 'Computer Science & Engineering',
      semester: '6th Semester',
      studentId: '2024-CSE-042',
      isPremium: true,
    );
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = UserModel(
      id: 'user_1',
      name: email.split('@').first.toUpperCase(),
      email: email,
      universityName: 'Dhaka University of Engineering & Technology',
      department: 'Computer Science & Engineering',
      semester: '6th Semester',
      studentId: '2024-CSE-042',
      isPremium: true,
    );
    await tokenStorage.saveTokens(accessToken: 'mock_jwt_token_for_${user.id}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppKeys.userProfile, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<UserModel> register({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = UserModel(
      id: 'user_1',
      name: name,
      email: email,
      universityName: 'Dhaka University of Engineering & Technology',
      department: 'Computer Science & Engineering',
      semester: '6th Semester',
      studentId: '2024-CSE-042',
      isPremium: false,
    );
    await tokenStorage.saveTokens(accessToken: 'mock_jwt_token_for_${user.id}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppKeys.userProfile, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppKeys.userProfile);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
