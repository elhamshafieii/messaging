import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messaging/models/user_model.dart';

abstract class ISelectContactDataSource {
  Future<UserModel?> selectContact(Contact selectedContact);
}

class SelectContactFirebaseDataSource implements ISelectContactDataSource {
  final FirebaseFirestore firestore;

  SelectContactFirebaseDataSource({required this.firestore});
  @override
  Future<UserModel?> selectContact(Contact selectedContact) async {
    String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
      ' ',
      '',
    );
    UserModel? contactUserModel;
    var userCollection = await firestore.collection('users').get();
    for (var document in userCollection.docs) {
      UserModel user = UserModel.fromMap(document.data());
      if (selectedPhoneNum == user.phoneNumber) {
        contactUserModel = user;
      }
    }
    return contactUserModel;
  }
}
