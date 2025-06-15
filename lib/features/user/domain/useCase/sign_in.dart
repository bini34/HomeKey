import 'package:MediTrack/features/user/domain/repositories/user_repository.dart';

class SignIn {
  final UserRepository repository;

  SignIn(this.repository);

  Future<void> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
