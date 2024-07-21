import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:messaging/common/enums/message_enum.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/audio_display.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/document_display.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/image_display.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/location_display.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/video_player.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/view_contact.dart';

class MyMessageCard extends StatelessWidget {
  final Message message;
  const MyMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    String formattedTime = DateFormat.Hm().format(message.dateTime);
    return MyMessageCardItem1(
        themeData: themeData, message: message, formattedTime: formattedTime);
  }
}

class MyMessageCardItem1 extends StatelessWidget {
  const MyMessageCardItem1({
    super.key,
    required this.themeData,
    required this.message,
    required this.formattedTime,
  });

  final ThemeData themeData;
  final Message message;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    switch (message.messageEnum) {
      case MessageEnum.text:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(15, 6, 27, 2),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                    minWidth: 32),
                child: Text(
                  textAlign: TextAlign.right,
                  message.text,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  formattedTime,
                  style: themeData.textTheme.labelSmall,
                ),
              )
            ],
          ),
        );
      case MessageEnum.image:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Stack(children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                    minWidth: 35),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageDisplay(message: message))),
            Positioned(
              bottom: 0,
              right: 10,
              child: Text(
                formattedTime,
                style: themeData.textTheme.labelSmall!
                    .copyWith(color: Colors.white),
              ),
            )
          ]),
        );
      case MessageEnum.video:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Stack(children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                    minWidth: 35),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: VideoPlayerWidget(message: message))),
            Positioned(
              bottom: 0,
              right: 10,
              child: Text(
                formattedTime,
                style: themeData.textTheme.labelSmall!
                    .copyWith(color: Colors.white),
              ),
            )
          ]),
        );
      case MessageEnum.location:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Stack(children: [
            Container(
                padding: const EdgeInsets.only(bottom: 20),
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.width * 0.45,
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                    minWidth: 35),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LocationDisplay(
                      message: message,
                    ))),
            Positioned(
              bottom: 0,
              right: 10,
              child: Text(
                formattedTime,
                style: themeData.textTheme.labelSmall,
              ),
            )
          ]),
        );
      case MessageEnum.document:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minWidth: 35),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: DocumentDisplay(message: message, isMyMessage: true,))),
        );
      case MessageEnum.contact:
        final Map<String, dynamic> selectedContact = json.decode(message.text);
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ViewContact(
                selectedContact: selectedContact,
              );
            }));
          },
          child: ChatBubble(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            backGroundColor: themeData.cardTheme.color,
            elevation: 1,
            clipper:
                ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
            child: Stack(children: [
              Container(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  height: 70,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                      minWidth: 35),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/profile_image_backgroung.png',
                            width: 60,
                            height: 60,
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          selectedContact['displayName'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 25, 116, 190)),
                        ),
                      )
                    ],
                  )),
              Positioned(
                bottom: 0,
                right: 10,
                child: Text(
                  formattedTime,
                  style: themeData.textTheme.labelSmall,
                ),
              )
            ]),
          ),
        );
      case MessageEnum.audio:
        return ChatBubble(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(5, 5, 19, 4),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          backGroundColor: themeData.cardTheme.color,
          elevation: 1,
          clipper: ChatBubbleClipper1(type: BubbleType.sendBubble, radius: 12),
          child: Stack(children: [
            AudioDisplay(
              message: message,
            ),
            Positioned(
              bottom: 0,
              right: 10,
              child: Text(
                formattedTime,
                style: themeData.textTheme.labelSmall,
              ),
            )
          ]),
        );

      default:
        return Container();
    }
  }
}
