
import '../../domain/entity/user.dart';
// import '../models/user_model.dart';

abstract class UserRepository {
  Future<User> createUser(User user);
  Future<User?> getUser(String userId);
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
}


