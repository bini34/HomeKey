// features/auth/provider/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../model/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
      final authRepository = ref.read(authRepositoryProvider);
      return AuthController(authRepository);
    });

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.loading()) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
      //  _ref
      //                 .read(userPropertyControllerProvider.notifier)
      //                 .loadUserProperties();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
