import 'package:messaging/models/user_model.dart';

class ChatContact {
  final UserModel contactUserModel;
  final DateTime dateTime;
  final String lastMessage;

  ChatContact(
      {required this.contactUserModel,
      required this.dateTime,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      'contactName': contactUserModel.name,
      'contactProfilePic': contactUserModel.profilePic,
      'contactUid': contactUserModel.uid,
      'phoneNumber': contactUserModel.phoneNumber,
      'isOnline': contactUserModel.isOnline,
      'dateTime': dateTime,
      'lastMessage': lastMessage,
      'about': contactUserModel.about
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      contactUserModel: UserModel(
        name: map['contactName'],
        about: map['about'],
        uid: map['contactUid'],
        profilePic: map['contactProfilePic'],
        phoneNumber: map['phoneNumber'],
        isOnline: map['isOnline'],
      ),
      lastMessage: map['lastMessage'] ?? '',
      dateTime: map['dateTime'].toDate(),
    );
  }
}
