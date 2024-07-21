import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/mobile_chat_screen/appbar_mobile_chat_screen/bloc/app_bar_mobile_chat_ecreen_bloc.dart';
import 'package:messaging/screens/mobile_chat_screen/mobile_chat_screen/contact_detail_screen.dart';

class AppBarMobileChatScreen extends StatelessWidget {
  final UserModel contactUserModel;
  const AppBarMobileChatScreen({
    super.key,
    required this.themeData,
    required this.contactUserModel,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBarMobileChatEcreenBloc>(
      create: (context) {
        final bloc = AppBarMobileChatEcreenBloc(
            uid: contactUserModel.uid, chatRepository: chatRepository);
        bloc.add(AppBarMobileChatScreenStarted());
        return bloc;
      },
      child: AppBar(
        title: BlocBuilder<AppBarMobileChatEcreenBloc,
            AppBarMobileChatEcreenState>(
          builder: (context, state) {
            if (state is AppBarMobileChatScreenError) {
              return IconButton(
                onPressed: () {
                  BlocProvider.of<AppBarMobileChatEcreenBloc>(context)
                      .add(AppBarMobileChatScreenStarted());
                },
                icon: const Icon(Icons.refresh),
              );
            } else if (state is AppBarMobileChatScreenLoading) {
              return const CupertinoActivityIndicator();
            } else if (state is AppBarMobileChatScreenSuccess) {
              return StreamBuilder<UserModel>(
                  stream: state.contactUserModelStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ContactDetailScreen(
                              contactUserModel: contactUserModel,
                            );
                          }));
                        },
                        child: Row(
                          children: [
                            snapshot.data!.profilePic != ''
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(
                                        snapshot.data!.profilePic!),
                                    radius: 20,
                                  )
                                : const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_image_backgroung.png'),
                                    radius: 20,
                                  ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    snapshot.data!.isOnline
                                        ? 'online'
                                        : 'offline',
                                    style: themeData.textTheme.bodySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      IconButton(
                          onPressed: () {
                            BlocProvider.of<AppBarMobileChatEcreenBloc>(context)
                                .add(AppBarMobileChatScreenStarted());
                          },
                          icon: const Icon(Icons.refresh));
                    } else {
                      return const CupertinoActivityIndicator();
                    }
                    return Container();
                  });
            } else {
              throw ('state is not protected.');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
