// features/user/repository/user_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homekey_mobile/features/auth/model/user_model.dart';

class UserRepository {
  final String _baseUrl = 'http://10.119.27.17:8080/api';

  Future<UserModel?> getUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // Add auth token if needed
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['data']['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
