// features/auth/repository/auth_repository.dart
import 'dart:convert';
import 'package:homekey_mobile/features/auth/services/auth_storage_service.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class AuthRepository {
  // final String _baseUrl =
  //     'http://localhost:8080/api/users';
  // // Replace with your API URL
  // final String _baseUrl =
  //     'http://10.190.189.17:8080/api/users';
  final String _baseUrl =
      'http://10.119.27.17:8080/api/users'; // Your actual IP
  final AuthStorageService _storage = AuthStorageService();

  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    print("Signing up with: $firstName $lastName, $email");
    print("Password: $password");
    final response = await http.post(
      Uri.parse('$_baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': '$firstName $lastName',
        'email': email,
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);

    print('Response status: ${response.body}');

    if (response.statusCode == 201) {
      final user = UserModel.fromJson(responseData);
      await _storage.saveToken(user.token);
      await _storage.saveUserData(responseData['data']['user']);
      return user;
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    print('Login response status: ${response.body}');

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(responseData);
      await _storage.saveToken(user.token);
      await _storage.saveUserData(responseData['data']['user']);
      return user;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/getUserData'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print("hi, ${response.body}");

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.clearAuthData();
  }
}
