import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/error_screen.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/profile/bloc/profile_bloc.dart';
import 'package:messaging/screens/profile/change_profile_photo/change_profile_picture_bag.dart';
import 'package:messaging/screens/profile/change_profile_setting_dialog/change_profile_setting_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: ()async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
          ),
          backgroundColor: themeData.scaffoldBackgroundColor,
          foregroundColor: const Color.fromRGBO(37, 45, 49, 1),
        ),
        body: BlocProvider<ProfileBloc>(
          create: (BuildContext context) {
            final profileBloc =
                ProfileBloc(chatRepository: chatRepository, uid: widget.uid);
            profileBloc.add(ProfileStarted());
            return profileBloc;
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileError) {
                return ErrorScreen(callback: () {
                  BlocProvider.of<ProfileBloc>(context).add(ProfileStarted());
                });
              } else if (state is ProfileLoading) {
                return Center(
                  child: loader(radius: 30, color: lightAppBarColor),
                );
              } else if (state is ProfileSuccess) {
                return StreamBuilder<UserModel>(
                  stream: state.userModelStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(children: [
                              snapshot.data!.profilePic != ''
                                  ? FutureBuilder(
                                      future: DefaultCacheManager()
                                          .getSingleFile(
                                              snapshot.data!.profilePic!),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage:
                                                FileImage(snapshot.data),
                                            radius: 70,
                                          );
                                        } else {
                                          return CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: const AssetImage(
                                                'assets/images/profile_image_backgroung.png'),
                                            radius: 70,
                                            child: Center(
                                                child: loader(
                                                    radius: 10,
                                                    color: lightTextColor)),
                                          );
                                        }
                                      },
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: AssetImage(
                                          'assets/images/profile_image_backgroung.png'),
                                      radius: 70,
                                    ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ChangeProfilePictureBag(
                                    userModel: snapshot.data!,
                                  )),
                            ]),
                            const SizedBox(
                              height: 24,
                            ),
                            ListTile(
                                title: Text(
                                  'Name',
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: lightTextColor),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    snapshot.data!.name.toUpperCase(),
                                    style: themeData.textTheme.bodyMedium!
                                        .copyWith(
                                            color: lightTextColor,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                                leading: const Icon(Icons.person,
                                    color: lightTextColor),
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<UserModel>(
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ChangeProfileSettingDialog(
                                              userModel: snapshot.data!,
                                              itemToBeChanged: 'name',
                                            ),
                                          );
                                        },
                                        context: context);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: themeData.colorScheme.primary,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 52),
                              child: Text(
                                'This is not your username or pin. This name will be visible to your contacts.',
                                style: themeData.textTheme.bodySmall!
                                    .copyWith(color: lightTextColor),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ListTile(
                                title: Text(
                                  'About',
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: lightTextColor),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    snapshot.data!.about != ''
                                        ? snapshot.data!.about
                                        : 'Hey there, I am using Messaging',
                                    style: themeData.textTheme.bodySmall!
                                        .copyWith(color: lightTextColor),
                                  ),
                                ),
                                leading: const Icon(Icons.info_outlined,
                                    color: lightTextColor),
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<UserModel>(
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ChangeProfileSettingDialog(
                                              userModel: snapshot.data!,
                                              itemToBeChanged: 'about',
                                            ),
                                          );
                                        },
                                        context: context);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: themeData.colorScheme.primary,
                                  ),
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            ListTile(
                                title: Text(
                                  'Phone',
                                  style: themeData.textTheme.bodyMedium!
                                      .copyWith(color: lightTextColor),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    snapshot.data!.phoneNumber,
                                    style: themeData.textTheme.bodyMedium!
                                        .copyWith(
                                            color: lightTextColor,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ),
                                leading: const Icon(Icons.phone,
                                    color: lightTextColor),
                                trailing: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<UserModel>(
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ChangeProfileSettingDialog(
                                              userModel: snapshot.data!,
                                              itemToBeChanged: 'phone',
                                            ),
                                          );
                                        },
                                        context: context);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: themeData.colorScheme.primary,
                                  ),
                                )),
                          ]);
                    } else if (snapshot.hasError) {
                      return ErrorScreen(callback: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(ProfileStarted());
                      });
                    } else {
                      return Center(
                        child: loader(radius: 30, color: lightAppBarColor),
                      );
                    }
                  },
                );
              } else {
                throw ('state is not supported ...');
              }
            },
          ),
        ),
      ),
    );
  }
}
