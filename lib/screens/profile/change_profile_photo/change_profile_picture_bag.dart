import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/profile/change_profile_photo/bloc/change_profile_photo_bloc.dart';

class ChangeProfilePictureBag extends StatefulWidget {
  final UserModel userModel;
  const ChangeProfilePictureBag({super.key, required this.userModel});

  @override
  State<ChangeProfilePictureBag> createState() =>
      _ChangeProfilePictureBagState();
}

class _ChangeProfilePictureBagState extends State<ChangeProfilePictureBag> {
  late StreamSubscription<ChangeProfilePhotoState>? stateSubscription;
  @override
  void dispose() {
    stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider<ChangeProfilePhotoBloc>(
      create: (BuildContext context) {
        final bloc = ChangeProfilePhotoBloc(
            authRepository: authRepository, userModel: widget.userModel);
        stateSubscription = bloc.stream.listen((state) {
          if (state is ChangeProfileSettingError) {
            showSnackBar(context: context, content: state.errorMessage);
          }
        });
        return bloc;
      },
      child: BlocBuilder<ChangeProfilePhotoBloc, ChangeProfilePhotoState>(
        builder: (context, state) {
          return InkWell(
            onTap: () async {
              if (state is ChangeProfileSettingLoading) {
                showSnackBar(context: context, content: 'Please wait ...');
              } else {
                final newProfilerPictureFile = await getNewProfilePicuture(
                    context: context, themeData: themeData);
                if (newProfilerPictureFile != null) {
                  if (context.mounted) {
                    BlocProvider.of<ChangeProfilePhotoBloc>(context).add(
                        ChangeProfilePhotoButtonClicked(
                            newProfilePicture: newProfilerPictureFile));
                  }
                }
              }
            },
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeData.colorScheme.primary),
                child: Center(
                  child: (state is ChangeProfileSettingLoading)
                      ? loader(radius: 10, color: Colors.white)
                      : const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                )),
          );
        },
      ),
    );
  }
}

Future<File?> getNewProfilePicuture(
    {required BuildContext context, required ThemeData themeData}) async {
  ImageSource? imageSource = await getImageSource(context, themeData);
  File? newProfilerPictureFile;
  if (imageSource != null) {
    if (context.mounted) {
      newProfilerPictureFile = await pickImageFromGalleryOrCamera(
        context: context,
        imageSource: imageSource,
      );
    }
  }
  return newProfilerPictureFile;
}

Future<ImageSource?> getImageSource(BuildContext context, ThemeData themeData) {
  return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile Photo',
                      style: themeData.textTheme.bodyLarge!.copyWith(
                          color: lightTextColor, fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.delete_forever,
                      color: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      onTap: () {
                        Navigator.of(context).pop(ImageSource.camera);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: themeData.primaryColor,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Camera',
                              style: themeData.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      onTap: () {
                        Navigator.of(context).pop(ImageSource.gallery);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Icon(Icons.browse_gallery,
                                color: themeData.primaryColor),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Galley',
                              style: themeData.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Icon(Icons.align_vertical_top_sharp,
                                color: themeData.primaryColor),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              'Avatar',
                              style: themeData.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}
