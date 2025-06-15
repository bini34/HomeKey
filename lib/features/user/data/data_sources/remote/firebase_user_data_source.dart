
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<auth.UserCredential> signIn(String email, String password);
  Future<auth.UserCredential> signUp(String email, String password);
  Future<void> signOut();
  auth.User? getCurrentUser();
}

class FirebaseUserDataSource implements UserRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Future<UserModel> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.userId).set(user.toJson());
    return user;
  }

  @override
  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.userId).update(user.toJson());
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<auth.UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<auth.UserCredential> signUp(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  auth.User? getCurrentUser() {
    return _auth.currentUser;
  }
}


