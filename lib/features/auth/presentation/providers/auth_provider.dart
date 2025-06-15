// import 'package:MediTrack/injection_container.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/user_entity.dart';
// import '../../domain/usecases/login.dart';
// // Notifier to manage authentication state using Riverpod.
// class AuthNotifier extends StateNotifier<AuthState> {
//   final Login loginUseCase;

//   AuthNotifier(this.loginUseCase) : super(const AuthInitial());

//   // Performs login and updates state based on the result.
//   Future<void> login(String email, String password) async {
//     state = const AuthLoading();
//     final result = await loginUseCase(LoginParams(email: email, password: password));
//     state = result.fold(
//       (failure) => AuthError(failure.message ?? 'Login failed'),
//       (user) => AuthSuccess(user),
//     );
//   }
// }

// // Authentication state classes.
// abstract class AuthState {
//   const AuthState();
// }

// class AuthInitial extends AuthState {
//   const AuthInitial();
// }

// class AuthLoading extends AuthState {
//   const AuthLoading();
// }

// class AuthSuccess extends AuthState {
//   final UserEntity user;
//   const AuthSuccess(this.user);
// }

// class AuthError extends AuthState {
//   final String message;
//   const AuthError(this.message);
// }

// // Riverpod provider for AuthNotifier.
// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   final loginUseCase = ref.watch(loginUseCaseProvider);
//   return AuthNotifier(loginUseCase);
// });

// // Provider for Login use case, integrating with GetIt.
// final loginUseCaseProvider = Provider<Login>((ref) => ref.read(getItProvider)<Login>());