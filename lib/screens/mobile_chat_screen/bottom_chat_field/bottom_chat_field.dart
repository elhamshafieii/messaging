import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/common/enums/message_enum.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/message_reply.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/bottom_chat_field/bloc/bottom_chat_field_bloc.dart';
import 'package:messaging/screens/mobile_chat_screen/bottom_chat_field/select_contact_to_send.dart';
import 'package:messaging/screens/mobile_chat_screen/bottom_chat_field/select_location.dart';
import 'package:messaging/screens/mobile_chat_screen/chat_list/chat_list.dart';

class BottomChatField extends StatefulWidget {
  final UserModel contactUserModel;

  const BottomChatField({super.key, required this.contactUserModel});
  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowMessageReply = false;
  MessageReply? messageReply;
  bool isShowSendButton = false;
  bool isShowAnimatedContainer = false;
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    ChatList.onMessageSwipNotifier.addListener(onMessageSwipNotifierListener);
    super.initState();
  }

  void onMessageSwipNotifierListener() {
    setState(() {
      messageReply = ChatList.onMessageSwipNotifier.value;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    ChatList.onMessageSwipNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    isShowMessageReply = messageReply != null;
    MessageEnum messageEnum = MessageEnum.text;
    return BlocProvider<BottomChatFieldBloc>(
      create: (context) {
        final bloc = BottomChatFieldBloc(
            contactUserModel: widget.contactUserModel,
            authRepository: authRepository,
            chatRepository: chatRepository);
        bloc.add(BottomChatFieldStarted());
        return bloc;
      },
      child: BlocBuilder<BottomChatFieldBloc, BottomChatFieldState>(
        builder: (context, state) {
          return Column(
            children: [
              isShowAnimatedContainer
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      width: MediaQuery.of(context).size.width - 20,
                      height: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 1,
                              spreadRadius: 1)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: GridView.builder(
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return AnimatedContainerItem(
                                  title: 'Document',
                                  icon: Icons.edit_document,
                                  backgroundColor: Colors.purple,
                                  onTap: () async {
                                    messageEnum = MessageEnum.document;
                                    final document =
                                        await FilePicker.platform.pickFiles(
                                      allowMultiple: false,
                                      type: FileType.any,
                                    );
                                    if (document != null) {
                                      File file = document.paths
                                          .map((path) => File(path!))
                                          .toList()[0];
                                      final bool isPermittedToSend =
                                          await checkFileSizeToSend(file);
                                      if (isPermittedToSend) {
                                        if (context.mounted) {
                                          context.read<BottomChatFieldBloc>().add(
                                              BottomChatFieldSendMessageClicked(
                                                  message: file.path,
                                                  messageEnum:
                                                      MessageEnum.document));
                                        }
                                        setState(() {
                                          isShowAnimatedContainer = false;
                                        });
                                      } else {
                                        if (context.mounted) {
                                          showSnackBar(
                                              context: context,
                                              content:
                                                  'File size should be less than 10 Mb ...');
                                        }
                                      }
                                    }
                                  });
                            case 1:
                              return AnimatedContainerItem(
                                title: 'Camera',
                                icon: Icons.camera_alt,
                                backgroundColor: Colors.pink,
                                onTap: () async {
                                  messageEnum = MessageEnum.image;
                                  final File? image =
                                      await pickImageFromGalleryOrCamera(
                                          context: context,
                                          imageSource: ImageSource.camera);
                                  if (image != null) {
                                    final bool isPermittedToSend =
                                        await checkFileSizeToSend(image);
                                    if (isPermittedToSend) {
                                      if (context.mounted) {
                                        context.read<BottomChatFieldBloc>().add(
                                            BottomChatFieldSendMessageClicked(
                                                messageEnum: messageEnum,
                                                message: image.path));
                                      }
                                      setState(() {
                                        isShowAnimatedContainer = false;
                                      });
                                    } else {
                                      if (context.mounted) {
                                        showSnackBar(
                                            context: context,
                                            content:
                                                'File size should be less than 10 Mb ...');
                                      }
                                    }
                                  }
                                },
                              );
                            case 2:
                              return AnimatedContainerItem(
                                title: 'Gallery',
                                icon: Icons.image,
                                backgroundColor: Colors.purple.shade300,
                                onTap: () async {
                                  messageEnum = MessageEnum.image;
                                  messageEnum = MessageEnum.image;
                                  final File? image =
                                      await pickImageFromGalleryOrCamera(
                                          context: context,
                                          imageSource: ImageSource.gallery);

                                  if (image != null) {
                                    final bool isPermittedToSend =
                                        await checkFileSizeToSend(image);
                                    if (isPermittedToSend) {
                                      if (context.mounted) {
                                        context.read<BottomChatFieldBloc>().add(
                                            BottomChatFieldSendMessageClicked(
                                                messageEnum: messageEnum,
                                                message: image.path));
                                      }
                                      setState(() {
                                        isShowAnimatedContainer = false;
                                      });
                                    } else {
                                      if (context.mounted) {
                                        showSnackBar(
                                            context: context,
                                            content:
                                                'File size should be less than 10 Mb ...');
                                      }
                                    }
                                  }
                                },
                              );
                            case 3:
                              return AnimatedContainerItem(
                                title: 'Audio',
                                icon: Icons.headphones,
                                backgroundColor: Colors.cyan,
                                onTap: () async {
                                  messageEnum = MessageEnum.audio;
                                  final File? audio = await pickFile(
                                    context: context,
                                    fileType: FileType.audio,
                                  );
                                  if (audio != null) {
                                    final bool isPermittedToSend =
                                        await checkFileSizeToSend(audio);
                                    if (isPermittedToSend) {
                                      if (context.mounted) {
                                        context.read<BottomChatFieldBloc>().add(
                                            BottomChatFieldSendMessageClicked(
                                                message: audio.path,
                                                messageEnum: messageEnum));
                                      }
                                      setState(() {
                                        isShowAnimatedContainer = false;
                                      });
                                    } else {
                                      if (context.mounted) {
                                        showSnackBar(
                                            context: context,
                                            content:
                                                'File size should be less than 10 Mb ...');
                                      }
                                    }
                                  }
                                },
                              );
                            case 4:
                              return AnimatedContainerItem(
                                title: 'Video',
                                icon: Icons.video_call,
                                backgroundColor: Colors.lightGreenAccent,
                                onTap: () async {
                                  messageEnum = MessageEnum.video;
                                  final File? video =
                                      await pickVideoFromGalleryOrCamera(
                                          context: context,
                                          imageSource: ImageSource.gallery);
                                  if (video != null) {
                                    final bool isPermittedToSend =
                                        await checkFileSizeToSend(video);
                                    if (isPermittedToSend) {
                                      if (context.mounted) {
                                        context.read<BottomChatFieldBloc>().add(
                                            BottomChatFieldSendMessageClicked(
                                                messageEnum: messageEnum,
                                                message: video.path));
                                      }
                                      setState(() {
                                        isShowAnimatedContainer = false;
                                      });
                                    } else {
                                      if (context.mounted) {
                                        showSnackBar(
                                            context: context,
                                            content:
                                                'File size should be less than 10 Mb ...');
                                      }
                                    }
                                  }
                                },
                              );
                            case 5:
                              return AnimatedContainerItem(
                                title: 'Location',
                                icon: Icons.add_location,
                                backgroundColor: Colors.orange,
                                onTap: () async {
                                  messageEnum = MessageEnum.location;
                                  final GeoPoint? geoPoint =
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                    return const SelectLocation();
                                  }));
                                  if (geoPoint != null) {
                                    if (context.mounted) {
                                      context.read<BottomChatFieldBloc>().add(
                                          BottomChatFieldSendMessageClicked(
                                              messageEnum: messageEnum,
                                              message: [
                                                geoPoint.latitude,
                                                geoPoint.longitude
                                              ].toString()));
                                    }
                                  }
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                  });
                                },
                              );
                            case 6:
                              return AnimatedContainerItem(
                                title: 'Contact',
                                icon: Icons.person,
                                backgroundColor: Colors.green,
                                onTap: () async {
                                  messageEnum = MessageEnum.contact;
                                  final Contact? selectedContact =
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                    return const SelectContactToSend();
                                  }));
                                  if (selectedContact != null) {
                                    if (context.mounted) {
                                      context.read<BottomChatFieldBloc>().add(
                                          BottomChatFieldSendMessageClicked(
                                              messageEnum: messageEnum,
                                              message: json
                                                  .encode(selectedContact)));
                                    }
                                  }
                                  setState(() {
                                    isShowAnimatedContainer = false;
                                  });
                                },
                              );
                            case 7:
                              return AnimatedContainerItem(
                                title: 'Poll',
                                icon: Icons.person,
                                backgroundColor: Colors.lime,
                                onTap: () {},
                              );
                            default:
                              return Container();
                          }
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ],
                          borderRadius: isShowMessageReply
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))
                              : BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            isShowMessageReply
                                ? MessageReplyPreview(
                                    messageReply: messageReply!,
                                    contactName: widget.contactUserModel.name,
                                  )
                                : Container(),
                            TextFormField(
                              style: themeData.textTheme.bodyMedium!,
                              //  focusNode: focusNode,
                              controller: _messageController,
                              onChanged: (val) {
                                if (val.isEmpty) {
                                  setState(() {
                                    isShowSendButton = false;
                                  });
                                } else {
                                  setState(() {
                                    isShowSendButton = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.grey,
                                  ),
                                ),
                                suffixIcon: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          messageEnum = MessageEnum.image;
                                          final File? image =
                                              await pickImageFromGalleryOrCamera(
                                                  context: context,
                                                  imageSource:
                                                      ImageSource.camera);
                                          if (image != null) {
                                            final bool isPermittedToSend =
                                                await checkFileSizeToSend(
                                                    image);
                                            if (isPermittedToSend) {
                                              if (context.mounted) {
                                                context
                                                    .read<BottomChatFieldBloc>()
                                                    .add(
                                                        BottomChatFieldSendMessageClicked(
                                                            messageEnum:
                                                                messageEnum,
                                                            message:
                                                                image.path));
                                              }
                                              setState(() {
                                                isShowAnimatedContainer = false;
                                              });
                                            } else {
                                              if (context.mounted) {
                                                showSnackBar(
                                                    context: context,
                                                    content:
                                                        'File size should be less than 10 Mb ...');
                                              }
                                            }
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isShowAnimatedContainer =
                                                !isShowAnimatedContainer;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.attach_file,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: 'Type a message!',
                                hintStyle: themeData.textTheme.bodyMedium!
                                    .copyWith(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        isShowSendButton
                            ? BlocProvider.of<BottomChatFieldBloc>(context).add(
                                BottomChatFieldSendMessageClicked(
                                    messageEnum: MessageEnum.text,
                                    message: _messageController.text))
                            : null;
                        _messageController.clear();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        child: Icon(
                          isShowSendButton ? Icons.send : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MessageReplyPreview extends StatelessWidget {
  final MessageReply messageReply;
  final String contactName;
  const MessageReplyPreview({
    super.key,
    required this.messageReply,
    required this.contactName,
  });

  @override
  Widget build(BuildContext context) {
    //  final messageFile = await DefaultCacheManager()
    //                           .getSingleFile(message.text);
    return Stack(children: [
      Container(
        margin: const EdgeInsets.all(5),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12))),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactName,
                      style: const TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Text(
                            getContactMessageSymbol(
                                messageEnum: messageReply.message.messageEnum,
                                messageText: messageReply.message.text),
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500))
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
            )
          ],
        ),
      ),
      Positioned(
          right: 5,
          top: 5,
          child: GestureDetector(
            onTap: () {
              ChatList.onMessageSwipNotifier.value = null;
            },
            child: Container(alignment: Alignment.topRight,
              height: 40,width: 40,
              child: Icon(
                CupertinoIcons.multiply,
                size: 20,
                color: Colors.grey.shade600,
              ),
            ),
          ))
    ]);
  }
}

class AnimatedContainerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;
  const AnimatedContainerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: backgroundColor,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey.shade500),
          )
        ],
      ),
    );
  }
}
