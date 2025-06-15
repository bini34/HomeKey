import 'package:equatable/equatable.dart';
import '../../domain/entity/user.dart';

class UserModel extends Equatable {
  final String id;
  final String email;

  const UserModel({required this.id, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email']);
  }

  UserEntity toEntity() => UserEntity(id: id, email: email);

  @override
  List<Object> get props => [id, email];
}
