// // features/user/provider/user_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:homekey_mobile/features/auth/model/user_model.dart';
// import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';

// final userDetailsProvider = FutureProvider.family<UserModel?, String>((
//   ref,
//   userId,
// ) async {
//   // Implement this to fetch user details from your API
//   // Example:
//   // final response = await http.get('$_baseUrl/api/user/$userId');
//   // return UserModel.fromJson(response.body);

//   // For now, let's just get from auth if it's the current user
//   final authState = ref.watch(authControllerProvider);
//   if (authState.value?.id == userId) {
//     return authState.value;
//   }
//   return null; // You'll need to implement API call for other users
// });

// features/user/provider/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/model/user_model.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import 'package:homekey_mobile/features/user/repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userDetailsProvider = FutureProvider.family<UserModel?, String>((
  ref,
  userId,
) async {
  final repository = ref.read(userRepositoryProvider);
  final authState = ref.watch(authControllerProvider);

  // Return current user if matches
  if (authState.value?.id == userId) {
    return authState.value;
  }

  return await repository.getUser(userId);
});
