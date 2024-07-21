import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/screens/mobile_layout/mobile_layout_screen.dart';
import 'package:messaging/screens/user_information/bloc/user_information_bloc.dart';

class UserInformationScreen extends StatefulWidget {
  final File defaultWallpaperFile;

  const UserInformationScreen({
    super.key,
    required this.defaultWallpaperFile,
  });

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final TextEditingController nameController = TextEditingController();
  late StreamSubscription<UserInformationState>? stateSubscription;
  void selectImage() async {
    image = await pickImageFromGalleryOrCamera(
        context: context, imageSource: ImageSource.gallery);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {}
  }

  @override
  void dispose() {
    stateSubscription?.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/profile_image_backgroung.png'),
                        radius: 64,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 64,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: 'Enter your name'),
                    ),
                  ),
                  BlocProvider<UserInformationBloc>(
                    create: (context) {
                      final bloc =
                          UserInformationBloc(authRepository: authRepository);
                      stateSubscription = bloc.stream.listen((state) {
                        if (state is UserInformationError) {
                          showSnackBar(
                              context: context, content: state.errorMessage);
                        } else if (state is UserInformationSuccess) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return MobileLayoutScreen(
                              userModel: state.userModel,
                              defaultWallpaperFile: widget.defaultWallpaperFile,
                            );
                          }));
                        }
                      });
                      bloc.add(UserInformationStatrted());
                      return bloc;
                    },
                    child:
                        BlocBuilder<UserInformationBloc, UserInformationState>(
                      builder: (context, state) {
                        if (state is UserInformationLoading) {
                          return const CupertinoActivityIndicator();
                        } else {
                          return IconButton(
                            onPressed: () {
                              BlocProvider.of<UserInformationBloc>(context).add(
                                  UserInformationOkClicked(
                                      name: nameController.text,
                                      profilePic: image));
                            },
                            icon: const Icon(
                              Icons.done,
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
