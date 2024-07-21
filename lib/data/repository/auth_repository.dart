import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:messaging/data/data_source/auth_data_source.dart';
import 'package:messaging/models/user_model.dart';

final authRepository = AuthRepository(
    dataSource: AuthFirebaseDataSource(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
        storage: FirebaseStorage.instance));

abstract class IAuthRepository {
  Future signInWithPhone(
      {required BuildContext context, required String phoneNumber});
  Future<UserModel> saveUserDataToFirebase(String name, File? profilePic);
  Future<void> changeUserDataInFirebase(UserModel newUserModel);
  Future<UserModel?> getCurrentUserData();
  Future<void> setUserStatus(bool isOnline);
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});
  @override
  Future signInWithPhone(
      {required BuildContext context, required String phoneNumber}) async {
    await dataSource.signInWithPhone(
        context: context, phoneNumber: phoneNumber);
  }

  @override
  Future<UserModel> saveUserDataToFirebase(
    String name,
    File? profilePic,
  ) async {
    UserModel userModel = await dataSource.saveUserDataToFirebase(
      name,
      profilePic,
    );
    return userModel;
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    return await dataSource.getCurrentUserData();
  }

  @override
  Future<void> setUserStatus(bool isOnline) {
    return dataSource.setUserStatus(isOnline);
  }

  @override
  Future<void> changeUserDataInFirebase(UserModel newUserModel) {
    return dataSource.changeUserDataInFirebase(newUserModel);
  }

  @override
  Future<void> signOut() {
    return dataSource.signOut();
  }
}
