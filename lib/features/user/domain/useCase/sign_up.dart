import "package:MediTrack/features/user/domain/repositories/user_repository.dart";

class SignUp {
  final UserRepository repository;

  SignUp(this.repository);

  Future<void> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}
