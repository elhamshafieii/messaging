import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/screens/profile/profile_screen.dart';
import 'package:messaging/screens/setting/chat_setting.dart';
import 'package:messaging/screens/setting/setting_screen/bloc/setting_screen_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              BlocProvider<SettingScreenBloc>(
                create: (context) {
                  final bloc =
                      SettingScreenBloc(authRepository: authRepository);
                  bloc.add(SettingScreenStarted());
                  return bloc;
                },
                child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
                  builder: (context, state) {
                    if (state is SettingScreenLoading) {
                      return Center(
                        child: loader(radius: 10, color: lightAppBarColor),
                      );
                    } else if (state is SettingScreenError) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<SettingScreenBloc>(context)
                              .add(SettingScreenStarted());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please try again ...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
                            ),
                            const Icon(CupertinoIcons.refresh,
                                color: Colors.white)
                          ],
                        ),
                      );
                    } else if (state is SettingScreenSuccess) {
                      return SettingItem(
                        themeData: themeData,
                        title: state.userModel!.name,
                        subtitle: state.userModel!.about,
                        trailing: IconButton(
                          icon: const Icon(Icons.qr_code_2,
                              size: 25, color: lightAppBarColor),
                          onPressed: () {},
                        ),
                        leading: state.userModel!.profilePic != ''
                            ? FutureBuilder(
                                future: DefaultCacheManager().getSingleFile(
                                    state.userModel!.profilePic!),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            FileImage(snapshot.data));
                                  } else {
                                    return const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                    );
                                  }
                                })
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: AssetImage(
                                    'assets/images/profile_image_backgroung.png'),
                                radius: 30,
                              ),
                        nextScreen: ProfileScreen(
                          uid: state.userModel!.uid,
                        ),
                        callback: () {
                          BlocProvider.of<SettingScreenBloc>(context)
                              .add(SettingScreenStarted());
                        },
                      );
                    } else {
                      throw ('state is not supported');
                    }
                  },
                ),
              ),
              getDivider(),
              SettingItem(
                leading: const Icon(Icons.key_outlined),
                subtitle: 'Security notifications,change number',
                title: 'Account',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.lock),
                subtitle: 'Block contacts, disappearing messages',
                title: 'Privacy',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.person_2_sharp),
                subtitle: 'Create, edit, profile photo',
                title: 'Avatar',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.chat),
                subtitle: 'Theme, wallpapers, chat history',
                title: 'Chats',
                trailing: const SizedBox(),
                nextScreen: const ChatSettingScreen(
                  title: 'Chats',
                ),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.notifications),
                subtitle: 'Message, group & call tones',
                title: 'Notifications',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.circle_outlined),
                subtitle: 'Nanetwork usage, auto-download',
                title: 'Storage and data',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.language),
                subtitle: 'English',
                title: 'App Language',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.help_outline),
                subtitle: 'Help center, contact us, privacy policy',
                title: 'Help',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              ),
              SettingItem(
                leading: const Icon(Icons.group),
                subtitle: '',
                title: 'Invite a friend',
                trailing: const SizedBox(),
                nextScreen: Container(),
                themeData: themeData,
                callback: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget leading;
  final Widget nextScreen;
  final VoidCallback callback;
  const SettingItem({
    super.key,
    required this.themeData,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.leading,
    required this.nextScreen,
    required this.callback,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return nextScreen;
        })).then((value) {
          callback();
        });
      },
      child: ListTile(
          title: Text(
            title,
            style: themeData.textTheme.bodyLarge,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              subtitle,
              style:
                  themeData.textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
          ),
          leading: leading,
          trailing: trailing),
    );
  }
}
