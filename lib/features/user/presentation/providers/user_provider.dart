import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:firebase_auth/firebase_auth.dart" as auth;
import "package:MediTrack/features/user/data/data_sources/local/hive_user_data_source.dart";
import "package:MediTrack/features/user/data/data_sources/remote/firebase_user_data_source.dart";
import "package:MediTrack/features/user/data/repository/user_repository_impl.dart";
import "package:MediTrack/features/user/domain/entity/user.dart";
import "package:MediTrack/features/user/domain/useCase/get_user.dart";
import "package:MediTrack/features/user/domain/useCase/sign_in.dart";
import "package:MediTrack/features/user/domain/useCase/sign_up.dart";
import "package:MediTrack/features/user/domain/useCase/sign_out.dart";
import "package:MediTrack/features/user/domain/useCase/update_user.dart";

final userLocalDataSourceProvider = Provider<UserLocalDataSource>(
  (ref) => HiveUserDataSourceImpl(),
);

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => FirebaseUserDataSource(),
);

final userRepositoryProvider = Provider<UserRepositoryImpl>(
  (ref) => UserRepositoryImpl(
    localDataSource: ref.read(userLocalDataSourceProvider),
    remoteDataSource: ref.read(userRemoteDataSourceProvider),
  ),
);

final getUserUseCaseProvider = Provider<GetUser>(
  (ref) => GetUser(ref.read(userRepositoryProvider)),
);

final signInUseCaseProvider = Provider<SignIn>(
  (ref) => SignIn(ref.read(userRepositoryProvider)),
);

final signUpUseCaseProvider = Provider<SignUp>(
  (ref) => SignUp(ref.read(userRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOut>(
  (ref) => SignOut(ref.read(userRepositoryProvider)),
);

final updateUserUseCaseProvider = Provider<UpdateUser>(
  (ref) => UpdateUser(ref.read(userRepositoryProvider)),
);

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<User?> {
  final UserRepositoryImpl _userRepository;

  UserNotifier(this._userRepository) : super(null) {
    auth.FirebaseAuth.instance.authStateChanges().listen((
      auth.User? firebaseUser,
    ) async {
      if (firebaseUser != null) {
        final user = await _userRepository.getUser(firebaseUser.uid);
        state = user;
      } else {
        state = null;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _userRepository.signIn(email, password);
      final firebaseUser = _userRepository.remoteDataSource.getCurrentUser();
      if (firebaseUser != null) {
        final user = await _userRepository.getUser(firebaseUser.uid);
        state = user;
      }
    } catch (e) {
      // Handle sign-in errors
      print("Sign-in error: $e");
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      await _userRepository.signUp(email, password);
      final firebaseUser = _userRepository.remoteDataSource.getCurrentUser();
      if (firebaseUser != null) {
        final newUser = User(
          userId: firebaseUser.uid,
          name: name,
          email: email,
          passwordHash: "", // Password hash is handled by Firebase Auth
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _userRepository.createUser(newUser);
        state = newUser;
      }
    } catch (e) {
      // Handle sign-up errors
      print("Sign-up error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
      state = null;
    } catch (e) {
      // Handle sign-out errors
      print("Sign-out error: $e");
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      state = user;
    } catch (e) {
      print("Update user error: $e");
      rethrow;
    }
  }
}
