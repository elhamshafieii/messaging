part of 'change_profile_photo_bloc.dart';

@immutable
sealed class ChangeProfilePhotoState {}

final class ChangeProfilePhotoInitial extends ChangeProfilePhotoState {}
final class ChangeProfileSettingLoading
    extends ChangeProfilePhotoState {}

final class ChangeProfileSettingError
    extends ChangeProfilePhotoState {
  final String errorMessage;

  ChangeProfileSettingError({required this.errorMessage});
}

final class ChangeProfileSettingSuccess
    extends ChangeProfilePhotoState {
  final UserModel newUserModel;
  ChangeProfileSettingSuccess({required this.newUserModel});
}
