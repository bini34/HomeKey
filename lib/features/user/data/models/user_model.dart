import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel {
  @HiveField(0) final String userId;
  @HiveField(1) final String name;
  @HiveField(2) final String email;
  @HiveField(3) final String passwordHash;
  @HiveField(4) final String? phoneNumber;
  @HiveField(5) final String? profilePicture;
  @HiveField(6) final DateTime createdAt;
  @HiveField(7) final DateTime updatedAt;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.phoneNumber,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.userId,
      name: user.name,
      email: user.email,
      passwordHash: user.passwordHash,
      phoneNumber: user.phoneNumber,
      profilePicture: user.profilePicture,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  User toEntity() {
    return User(
      userId: userId,
      name: name,
      email: email,
      passwordHash: passwordHash,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}


