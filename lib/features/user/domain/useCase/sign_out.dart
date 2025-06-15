import "package:MediTrack/features/user/domain/repositories/user_repository.dart";

class SignOut {
  final UserRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
