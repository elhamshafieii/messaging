import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging/common/utils/wallpaper_manager.dart';
import 'package:messaging/data/hive_wallpaper/hive_wallpaper.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/appbar_mobile_chat_screen/appbar_mobile_chat_screen.dart';
import 'package:messaging/screens/mobile_chat_screen/bottom_chat_field/bottom_chat_field.dart';
import 'package:messaging/screens/mobile_chat_screen/chat_list/chat_list.dart';

class MobileChatScreen extends StatefulWidget {
  final File defaultWallpaperFile;
  final UserModel userModel;
  final UserModel contactUserModel;
  const MobileChatScreen({
    super.key,
    required this.contactUserModel,
    required this.userModel,
    required this.defaultWallpaperFile,
  });

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  bool isShowReplyBox = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Wallpaper>(wallpaperBoxName);
    final currentWallpaper = box.get('wallpaper');
    final wallpaperFile = currentWallpaper != null
        ? File(currentWallpaper.wallpaperPath)
        : widget.defaultWallpaperFile;
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBarMobileChatScreen(
              themeData: themeData,
              contactUserModel: widget.contactUserModel,
            )),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.file(wallpaperFile).image,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: ChatList(
                contactUserModel: widget.contactUserModel,
                userModel: widget.userModel,
              )),
              Column(
                children: [
                  isShowReplyBox
                      ? Container(
                          width: 200,
                          height: 100,
                          color: Colors.red,
                        )
                      : Container(),
                  BottomChatField(
                    contactUserModel: widget.contactUserModel,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
