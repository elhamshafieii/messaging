import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/error_screen.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/chat_contact.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/mobile_chat_screen.dart';
import 'package:messaging/screens/chat_contact_list/bloc/chat_contact_list_bloc.dart';

class ChatContactsList extends StatelessWidget {
  final File defaultWallpaperFile;
  final UserModel userModel;
  const ChatContactsList(
      {super.key, required this.userModel, required this.defaultWallpaperFile});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatContactListBloc>(create: (context) {
          final chatContactListBloc =
              ChatContactListBloc(chatRepository: chatRepository);
          chatContactListBloc.add(ChatContactListStarted());
          return chatContactListBloc;
        }),
      ],
      child: BlocBuilder<ChatContactListBloc, ChatContactListState>(
        builder: (context, state) {
          if (state is ChatContactListLoading) {
            return Container(
              alignment: Alignment.center,
              child: Center(
                child: loader(radius: 30, color: lightAppBarColor),
              ),
            );
          } else if (state is ChatContactListError) {
            return ErrorScreen(
              callback: () {
                BlocProvider.of<ChatContactListBloc>(context)
                    .add(ChatContactListStarted());
              },
            );
          } else if (state is ChatContactListSuccess) {
            return StreamBuilder<List<ChatContact>>(
                stream: state.chatContactList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: loader(radius: 30, color: lightAppBarColor),
                    );
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var chatContact = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return MobileChatScreen(
                                  contactUserModel:
                                      chatContact.contactUserModel,
                                  userModel: userModel,
                                  defaultWallpaperFile: defaultWallpaperFile,
                                );
                              }));
                            },
                            child: ListTile(
                              title: Text(
                                chatContact.contactUserModel.name,
                                style: themeData.textTheme.bodyLarge,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  chatContact.lastMessage,
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                              leading:
                                  chatContact.contactUserModel.profilePic != ''
                                      ? CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  chatContact.contactUserModel
                                                      .profilePic!),
                                          radius: 30,
                                        )
                                      : const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: AssetImage(
                                              'assets/images/no_profile_pic.png'),
                                          radius: 30,
                                        ),
                            ),
                          );
                        }),
                  );
                });
          } else {
            throw ('state is not supported.');
          }
        },
      ),
    );
  }
}
