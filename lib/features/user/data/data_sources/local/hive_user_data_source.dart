import 'package:hive/hive.dart';
import 'package:MediTrack/features/user/data/models/user_model.dart';

part 'hive_user_data_source.g.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> deleteUser(String userId);
}

@HiveType(typeId: 1)
class HiveUserDataSourceImpl implements UserLocalDataSource {
  static const String _userBoxName = 'userBox';

  @override
  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.put(user.userId, user);
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    return box.get(userId);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final box = await Hive.openBox<UserModel>(_userBoxName);
    await box.delete(userId);
  }
}
