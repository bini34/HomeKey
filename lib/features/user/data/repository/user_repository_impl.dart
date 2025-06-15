import '../../domain/entity/user.dart';
import '../data_sources/local/hive_user_data_source.dart';
import '../data_sources/remote/firebase_user_data_source.dart';
import '../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<User> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await localDataSource.saveUser(userModel);
    await remoteDataSource.createUser(userModel);
    return user;
  }

  @override
  Future<User?> getUser(String userId) async {
    // Try to get from local first
    UserModel? userModel = await localDataSource.getUser(userId);
    if (userModel != null) {
      return userModel.toEntity();
    }
    // If not in local, get from remote and save to local
    userModel = await remoteDataSource.getUser(userId);
    if (userModel != null) {
      await localDataSource.saveUser(userModel);
      return userModel.toEntity();
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await localDataSource.saveUser(userModel);
    await remoteDataSource.updateUser(userModel);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await localDataSource.deleteUser(userId);
    await remoteDataSource.deleteUser(userId);
  }

  @override
  Future<void> signIn(String email, String password) async {
    await remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    await remoteDataSource.signUp(email, password);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    final firebaseUser = remoteDataSource.getCurrentUser();
    if (firebaseUser != null) {
      // This is a simplified conversion. In a real app, you'd fetch the full UserModel from Firestore.
      return User(userId: firebaseUser.uid, name: firebaseUser.displayName ?? '', email: firebaseUser.email ?? '', passwordHash: '', createdAt: DateTime.now(), updatedAt: DateTime.now());
    }
    return null;
  }
}


