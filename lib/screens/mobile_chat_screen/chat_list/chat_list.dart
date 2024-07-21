import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/error_screen.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/models/message_reply.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/chat_list/bloc/chat_list_bloc.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/my_message_card.dart';
import 'package:messaging/screens/mobile_chat_screen/widgets/sender_message_card.dart';
import 'package:screenshot/screenshot.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatList extends StatefulWidget {
  static ValueNotifier<MessageReply?> onMessageSwipNotifier =
      ValueNotifier(null);

  final UserModel userModel;
  final UserModel contactUserModel;

  const ChatList({
    super.key,
    required this.contactUserModel,
    required this.userModel,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Image? onMessageSwipNotifierScreenshot;
  ScreenshotController screenshotController = ScreenshotController();
  final ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onMessageSwip({
    required Message message,
    required bool isReplyMyMessage,
  }) async {
    ChatList.onMessageSwipNotifier.value = MessageReply(
      message: message,
      isReplyMyMessage: isReplyMyMessage,
    );
  }

  Image capturedWidgetScreenshpot(
      BuildContext context, Uint8List capturedImage) {
    return Image.memory(capturedImage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatListBloc>(
      create: (context) {
        final bloc = ChatListBloc(widget.contactUserModel,
            chatRepository: chatRepository);
        bloc.add(ChatListStarted());
        return bloc;
      },
      child: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is ChatListLoading) {
            return Center(
              child: loader(radius: 30, color: lightAppBarColor),
            );
          } else if (state is ChatListError) {
            return ErrorScreen(
              callback: () {
                BlocProvider.of<ChatListBloc>(context).add(ChatListStarted());
              },
            );
          } else if (state is ChatListSuccess) {
            return StreamBuilder(
                stream: state.chatList,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: loader(radius: 30, color: lightBackgroundColor),
                    );
                  }
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  });
                  return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(top: 10),
                      physics: defaultScrollPhysics,
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        final message = snapshot.data![index];
                        if (message.senderUid == widget.userModel.uid) {
                          final myMessageCardContainer = MyMessageCard(
                            message: message,
                          );
                          return SwipeTo(
                            onLeftSwipe: (DragUpdateDetails detail) async {
                              screenshotController
                                  .captureFromLongWidget(
                                InheritedTheme.captureAll(context,
                                    Material(child: myMessageCardContainer)),
                                delay: Duration(milliseconds: 100),
                                context: context,
                              )
                                  .then((capturedImage) {
                                setState(() {
                                  onMessageSwipNotifierScreenshot =
                                      capturedWidgetScreenshpot(
                                          context, capturedImage);
                                });
                              });
                              onMessageSwip(
                                  message: message, isReplyMyMessage: false);
                            },
                            child: Screenshot(
                              controller: screenshotController,
                              child: MyMessageCard(
                                message: message,
                              ),
                            ),
                          );
                        } else {
                          return SwipeTo(
                            onLeftSwipe: (DragUpdateDetails detail) async {
                              onMessageSwip(
                                  message: message, isReplyMyMessage: true);
                            },
                            child: SenderMessageCard(
                              message: message,
                            ),
                          );
                        }
                      }));
                }));
          } else {
            throw ('state is not supported.');
          }
        },
      ),
    );
  }
}
