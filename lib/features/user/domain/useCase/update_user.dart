import "package:MediTrack/features/user/domain/entity/user.dart";
import "package:MediTrack/features/user/domain/repositories/user_repository.dart";

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(User user) async {
    return await repository.updateUser(user);
  }
}
