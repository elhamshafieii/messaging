import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messaging/common/enums/message_enum.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/models/chat_contact.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

abstract class IChatDataSource {
  Stream<UserModel> getUserModelStream(String uid);
  Future<void> sendMessage(
      {required UserModel contactUserModel,
      required UserModel userModel,
      required MessageEnum messageEnum,
      required String message});
  Stream<List<ChatContact>> getChatContacts();
  Stream<List<Message>> getChatStream(String contactUid);
  Future<List<String>> getWallpapers(String wallpaperType);
  Future<String> getDefaultWallPaper();
}

class ChatFirebaseDataSource implements IChatDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ChatFirebaseDataSource(
      {required this.storage, required this.firestore, required this.auth});

  @override
  Stream<UserModel> getUserModelStream(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data()!);
    });
  }

  @override
  Future<void> sendMessage(
      {required UserModel contactUserModel,
      required UserModel userModel,
      required MessageEnum messageEnum,
      required String message}) async {
    DateTime dateTime = DateTime.now();
    var messageId = const Uuid().v1();
    String fileName = '';
    String fileUrl = '';
    if (messageEnum == MessageEnum.image ||
        messageEnum == MessageEnum.video ||
        messageEnum == MessageEnum.document ||
        messageEnum == MessageEnum.audio) {
      File file = File(message);
      fileName = p.basename(file.path);
      String filePath =
          'chat/${messageEnum.type}/${userModel.uid}/${contactUserModel.uid}/$messageId/$fileName';
      await storage.ref(filePath).putFile(file);
      fileUrl = await storage.ref(filePath).getDownloadURL();
    }
    String contactMsg =
        getContactMessageSymbol(messageText: message, messageEnum: messageEnum);
    // switch (messageEnum) {
    //   case MessageEnum.image:
    //     contactMsg = '📷 Photo';
    //     break;
    //   case MessageEnum.video:
    //     contactMsg = '📹 Video';
    //     break;
    //   case MessageEnum.audio:
    //     contactMsg = '🎵 Audio';
    //     break;
    //   case MessageEnum.gif:
    //     contactMsg = 'GIF';
    //     break;
    //   case MessageEnum.document:
    //     contactMsg = '📃 Document';
    //     break;
    //   case MessageEnum.contact:
    //     contactMsg = '📒 Contact';
    //     break;
    //   case MessageEnum.location:
    //     contactMsg = '📍 location';
    //     break;
    //   case MessageEnum.text:
    //     contactMsg = message;
    //     break;
    //   default:
    //     contactMsg = 'message';
    // }
    _saveDataToContactSubCollection(
        userModel: userModel,
        contactUserModel: contactUserModel,
        text: contactMsg,
        dateTime: dateTime);
    _saveMessageToMessageSubcollection(
        contactUserModel: contactUserModel,
        userModel: userModel,
        text: (messageEnum == MessageEnum.text ||
                messageEnum == MessageEnum.contact ||
                messageEnum == MessageEnum.location)
            ? message
            : fileUrl,
        dateTime: dateTime,
        messageId: messageId,
        messageEnum: messageEnum,
        isSeen: false,
        fileName: fileName);
  }

  _saveDataToContactSubCollection(
      {required UserModel userModel,
      required UserModel contactUserModel,
      required String text,
      required DateTime dateTime}) async {
    ChatContact recieverChatContact = ChatContact(
        contactUserModel: userModel, dateTime: dateTime, lastMessage: text);
    await firestore
        .collection('users')
        .doc(contactUserModel.uid)
        .collection('chats')
        .doc(userModel.uid)
        .set(recieverChatContact.toMap());
    ChatContact senderChatContact = ChatContact(
        contactUserModel: contactUserModel,
        dateTime: dateTime,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(contactUserModel.uid)
        .set(senderChatContact.toMap());
  }

  _saveMessageToMessageSubcollection(
      {required UserModel userModel,
      required UserModel contactUserModel,
      required String text,
      required DateTime dateTime,
      required String messageId,
      required MessageEnum messageEnum,
      required bool isSeen,
      required String fileName}) async {
    final message = Message(
        senderUid: userModel.uid,
        recieverUid: contactUserModel.uid,
        text: text,
        dateTime: dateTime,
        messageId: messageId,
        messageEnum: messageEnum,
        isSeen: isSeen,
        fileName: fileName);
    await firestore
        .collection('users')
        .doc(userModel.uid)
        .collection('chats')
        .doc(contactUserModel.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
    await firestore
        .collection('users')
        .doc(contactUserModel.uid)
        .collection('chats')
        .doc(userModel.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  @override
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('dateTime')
        .snapshots()
        .asyncMap((event) {
      List<ChatContact> chatContacts = [];
      for (var document in event.docs) {
        ChatContact chatContact = ChatContact.fromMap(document.data());
        chatContacts.add(chatContact);
      }

      return chatContacts;
    });
  }

  @override
  Stream<List<Message>> getChatStream(String contactUid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(contactUid)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  @override
  Future<List<String>> getWallpapers(String wallpaperType) async {
    List<String> wallpapersUrlList = [];
    final storageRef = storage.ref().child('wallpapers/$wallpaperType');
    final ListResult wallpaperListResult = await storageRef.listAll();
    final List<Reference> wallpaperList = wallpaperListResult.items;
    for (Reference ref in wallpaperList) {
      wallpapersUrlList.add(await ref.getDownloadURL());
    }
    return wallpapersUrlList;
  }

  @override
  Future<String> getDefaultWallPaper() async {
    final storageRef = storage.ref().child('wallpapers/default_wallpaper.png');
    final String defaultWallpaperUrl = await storageRef.getDownloadURL();
    return defaultWallpaperUrl;
  }
}
