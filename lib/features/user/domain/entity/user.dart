import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/basic.dart';

class User extends Equatable {
  final String userId;
  final String name;
  final String email;
  final String passwordHash;
  final String? phoneNumber;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.userId,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.phoneNumber,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        passwordHash,
        phoneNumber,
        profilePicture,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? userId,
    String? name,
    String? email,
    String? passwordHash,
    String? phoneNumber,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}


