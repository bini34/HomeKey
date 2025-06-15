import 'package:MediTrack/features/auth/domain/entity/user.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/usecase.dart';

class SignInUseCase implements UseCase<UserEntity, Params<UserEntity>> {
  final AuthRepository authRepository;
  SignInUseCase(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(Params params) async {
    // Business logic for signing in
    return await authRepository.signIn(params.data);
  }
}
