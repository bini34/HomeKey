import 'package:MediTrack/features/user/domain/entity/user.dart';
import 'package:MediTrack/features/user/domain/repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser(this.repository);

  Future<User?> call(String userId) async {
    return await repository.getUser(userId);
  }
}
