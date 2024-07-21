import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/auth/otp/otp_screen.dart';

abstract class IAuthDataSource {
  Future signInWithPhone(
      {required BuildContext context, required String phoneNumber});
  Future<UserModel> saveUserDataToFirebase(
    String name,
    File? profilePic,
  );
  Future<void> changeUserDataInFirebase(UserModel newUserModel);
  Future<UserModel?> getCurrentUserData();
  Future<void> setUserStatus(bool isOnline);
  Future<void> signOut();
}

class AuthFirebaseDataSource implements IAuthDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  AuthFirebaseDataSource(
      {required this.storage, required this.firestore, required this.auth});
  @override
  Future signInWithPhone(
      {required BuildContext context, required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            return OTPScreen(
              verificationId: verificationId,
            );
          }));
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: result);
          await auth.signInWithCredential(credential);
          if (context.mounted) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return const UserInformationScreen();
            // }));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  @override
  Future<UserModel> saveUserDataToFirebase(
    String name,
    File? profilePic,
  ) async {
    String uid = auth.currentUser!.uid;
    String photoUrl = '';
    if (profilePic != null) {
      UploadTask uploadTask =
          storage.ref().child('profilePic/$uid/$uid').putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
    }
    final user = UserModel(
      name: name,
      uid: uid,
      profilePic: photoUrl,
      phoneNumber: auth.currentUser!.phoneNumber!,
      isOnline: true,
      about: 'Hey there, I am using Messaging',
    );
    await firestore.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? userModel;
    if (userData.data() != null) {
      userModel = UserModel.fromMap(userData.data()!);
    }
    return userModel;
  }

  @override
  Future<void> setUserStatus(bool isOnline) async {
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'isOnline': isOnline,
    });
  }

  @override
  Future<void> changeUserDataInFirebase(UserModel newUserModel) async {
    await firestore
        .collection('users')
        .doc(newUserModel.uid)
        .set(newUserModel.toMap());
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
