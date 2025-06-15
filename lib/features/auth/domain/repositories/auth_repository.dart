import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/user.dart';

// Abstract interface for authentication operations.
// Used by the domain layer to define what operations are available without knowing how they’re implemented.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(UserEntity user);
  Future<bool> isUserLoggedIn();
  Future<UserEntity?> getCurrentUser();
}