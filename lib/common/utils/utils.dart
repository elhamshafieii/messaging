import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:messaging/common/enums/message_enum.dart';
import 'package:path_provider/path_provider.dart';


ScrollPhysics defaultScrollPhysics = const BouncingScrollPhysics();

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGalleryOrCamera(
    {required BuildContext context, required ImageSource imageSource}) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGalleryOrCamera(
    {required BuildContext context, required ImageSource imageSource}) async {
  File? video;
  try {
    final pickedImage = await ImagePicker().pickVideo(source: imageSource);
    if (pickedImage != null) {
      video = File(pickedImage.path);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<File?> pickFile(
    {required BuildContext context, required FileType fileType}) async {
  File? file;
  try {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result != null) {
      file = File(result.files.single.path!);
    }
  } catch (e) {
    if (context.mounted) showSnackBar(context: context, content: e.toString());
  }
  return file;
}

Future<List<Contact>> getContact({required String searchTerm}) async {
  List<Contact> allContactList = [];
  List<Contact> contacts = [];
  try {
    final bool isPermissionGranted = await FlutterContacts.requestPermission();
    if (isPermissionGranted) {
      allContactList = await FlutterContacts.getContacts(
        withProperties: true,
      );
      for (var contact in allContactList) {
        if (contact.phones.isNotEmpty &&
            contact.displayName.contains(searchTerm)) {
          contacts.add(contact);
        }
      }
    } else {
      await FlutterContacts.requestPermission();
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return contacts;
}

String getFileExtension({required File fileName}) {
  return (fileName.path.split('.').last).toLowerCase();
}

String getFileName({required File fileName}) {
  return (fileName.path.split('.').last).toLowerCase();
}

Future<bool> checkFileSizeToSend(File file) async {
  int fileSize = await file.length();
  return fileSize < 10000000 ? true : false;
}

String getRandomString(int length) =>
    String.fromCharCodes(Iterable.generate(length, (_) {
      const chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      Random rnd = Random();
      return chars.codeUnitAt(rnd.nextInt(chars.length));
    }));

getDivider() {
  return Divider(
    color: Colors.grey.shade200,
  );
}

navigateToOtherScreen(BuildContext context, Widget nextScreen) async {
  await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return nextScreen;
  }));
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');
  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
}

String getContactMessageSymbol(
    {required MessageEnum messageEnum, required String messageText}) {
  String contactMsg;
  switch (messageEnum) {
    case MessageEnum.image:
      contactMsg = '📷 Photo';
      break;
    case MessageEnum.video:
      contactMsg = '📹 Video';
      break;
    case MessageEnum.audio:
      contactMsg = '🎵 Audio';
      break;
    case MessageEnum.gif:
      contactMsg = 'GIF';
      break;
    case MessageEnum.document:
      contactMsg = '📃 Document';
      break;
    case MessageEnum.contact:
      contactMsg = '📒 Contact';
      break;
    case MessageEnum.location:
      contactMsg = '📍 location';
      break;
    case MessageEnum.text:
      contactMsg = messageText;
      break;
    default:
      contactMsg = 'message';
  }
  return contactMsg;
}
