// features/auth/model/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  // final String? password;
  final String role;
  final bool active;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    // this.password,
    required this.role,
    required this.active,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user data if present
    final userData =
        json['data']?['user'] ?? json['data']?['currentUser'] ?? json;

    return UserModel(
      id: userData['_id'] ?? userData['id'] ?? '',
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      // password: userData['password'],
      role: userData['role'] ?? '',
      active: userData['active'] ?? false,
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'active': active,
      //  if (password != null) 'password': password,
    };
  }
}
