import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messaging/common/enums/message_enum.dart';
import 'package:messaging/data/data_source/chat_data_source.dart';
import 'package:messaging/models/chat_contact.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/models/user_model.dart';

final chatRepository = ChatRepository(
    dataSource: ChatFirebaseDataSource(
  firestore: FirebaseFirestore.instance,
  auth: FirebaseAuth.instance,
  storage: FirebaseStorage.instance,
));

abstract class IChatRepository {
  Stream<UserModel> getUserModelStream(String uid);
  Future<void> sendMessage(
      {required UserModel contactUserModel,
      required UserModel userModel,
      required MessageEnum messageEnum,
      required String message});
  Stream<List<ChatContact>> getChatContacts();
  Stream<List<Message>> getChatStream(String uid);
  Future<List<String>> getWallpapers(String wallpaperType);
  Future<String> getDefaultWallPaper();
}

class ChatRepository implements IChatRepository {
  final IChatDataSource dataSource;

  ChatRepository({required this.dataSource});
  @override
  Stream<UserModel> getUserModelStream(String uid) {
    return dataSource.getUserModelStream(uid);
  }

  @override
  Future<void> sendMessage(
      {required UserModel contactUserModel,
      required UserModel userModel,
      required MessageEnum messageEnum,
      required String message}) {
    return dataSource.sendMessage(
        contactUserModel: contactUserModel,
        userModel: userModel,
        message: message,
        messageEnum: messageEnum);
  }

  @override
  Stream<List<ChatContact>> getChatContacts() {
    return dataSource.getChatContacts();
  }

  @override
  Stream<List<Message>> getChatStream(String contactUid) {
    return dataSource.getChatStream(contactUid);
  }

  @override
  Future<List<String>> getWallpapers(String wallpaperType) {
    return dataSource.getWallpapers(wallpaperType);
  }

  @override
  Future<String> getDefaultWallPaper() {
    return dataSource.getDefaultWallPaper();
  }
}
