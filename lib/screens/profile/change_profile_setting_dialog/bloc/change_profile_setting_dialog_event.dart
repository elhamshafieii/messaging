part of 'change_profile_setting_dialog_bloc.dart';

@immutable
sealed class ChangeProfileSettingDialogEvent {}

final class ChangeProfileSettingDialogSaveButtonClicked
    extends ChangeProfileSettingDialogEvent {
  final UserModel newUserModel;

  ChangeProfileSettingDialogSaveButtonClicked({required this.newUserModel});
}
