// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'core/network/network_info.dart';
// import 'features/auth/data/data_sources/remote/auth_firebase_datasource.dart';
// import 'features/auth/data/repository/auth_repository_impl.dart';
// import 'features/auth/domain/repositories/auth_repository.dart';
// import 'features/auth/domain/usecases/login.dart';

// // Global GetIt instance for dependency injection.
// final sl = GetIt.instance;

// // Provider for GetIt to integrate with Riverpod.
// final getItProvider = Provider<GetIt>((ref) => sl);

// // Initialize dependencies.
// Future<void> init() async {
//   // Firebase: Singleton instance.
//   sl.registerLazySingleton(() => FirebaseAuth.instance);

//   // Network: Connectivity and NetworkInfo.
//   sl.registerLazySingleton(() => Connectivity());
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//   // Data Layer: Data source and repository.
//   sl.registerLazySingleton<AuthFirebaseDataSource>(
//     () => AuthFirebaseDataSourceImpl(sl()),
//   );
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(sl(), sl()),
//   );

//   // Domain Layer: Use case.
//   sl.registerLazySingleton(() => Login(sl()));
// }