import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/profile/change_profile_setting_dialog/bloc/change_profile_setting_dialog_bloc.dart';

class ChangeProfileSettingDialog extends StatefulWidget {
  final UserModel userModel;
  final String itemToBeChanged;

  const ChangeProfileSettingDialog(
      {super.key, required this.userModel, required this.itemToBeChanged});

  @override
  State<ChangeProfileSettingDialog> createState() =>
      _ChangeProfileSettingDialogState();
}

class _ChangeProfileSettingDialogState
    extends State<ChangeProfileSettingDialog> {
  String hintText = '';
  final TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (widget.itemToBeChanged == 'name') {
      setState(() {
        hintText = widget.userModel.name;
      });
    } else if (widget.itemToBeChanged == 'about') {
      setState(() {
        if (widget.userModel.about.isEmpty) {
          hintText = 'Hey there, I am using Messaging';
        } else {
          hintText = widget.userModel.about;
        }
      });
    } else if (widget.itemToBeChanged == 'phone') {
      setState(() {
        hintText = widget.userModel.phoneNumber;
      });
    }

    return BlocProvider<ChangeProfileSettingDialogBloc>(
      create: (context) {
        final bloc =
            ChangeProfileSettingDialogBloc(authRepository: authRepository);
        return bloc;
      },
      child: BlocBuilder<ChangeProfileSettingDialogBloc,
          ChangeProfileSettingDialogState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your ${widget.itemToBeChanged}',
                    style: themeData.textTheme.bodyLarge!),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: themeData.textTheme.labelLarge!
                          .copyWith(color: Colors.grey.shade400)),
                  controller: controller,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () {
                          UserModel newUserModel = UserModel(
                              about: widget.itemToBeChanged == 'about'
                                  ? controller.text
                                  : widget.userModel.about,
                              name: widget.itemToBeChanged == 'name'
                                  ? controller.text
                                  : widget.userModel.name,
                              uid: widget.userModel.uid,
                              profilePic: widget.userModel.profilePic,
                              phoneNumber: widget.userModel.phoneNumber,
                              isOnline: widget.userModel.isOnline);
                          BlocProvider.of<ChangeProfileSettingDialogBloc>(
                                  context)
                              .add(ChangeProfileSettingDialogSaveButtonClicked(
                                  newUserModel: newUserModel));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
