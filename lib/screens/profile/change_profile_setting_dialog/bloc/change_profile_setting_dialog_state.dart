part of 'change_profile_setting_dialog_bloc.dart';

@immutable
sealed class ChangeProfileSettingDialogState {}

final class ChangeProfileSettingDialogInitial
    extends ChangeProfileSettingDialogState {}

final class ChangeProfileSettingDialogLoading
    extends ChangeProfileSettingDialogState {}

final class ChangeProfileSettingDialogError
    extends ChangeProfileSettingDialogState {
  final String errorMessage;

  ChangeProfileSettingDialogError({required this.errorMessage});
}

final class ChangeProfileSettingDialogSuccess
    extends ChangeProfileSettingDialogState {
  final UserModel userModel;
  ChangeProfileSettingDialogSuccess({required this.userModel});
}
