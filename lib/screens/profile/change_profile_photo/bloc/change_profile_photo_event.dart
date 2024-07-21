part of 'change_profile_photo_bloc.dart';

@immutable
sealed class ChangeProfilePhotoEvent {}

final class ChangeProfilePhotoButtonClicked extends ChangeProfilePhotoEvent {
  final File newProfilePicture;

  ChangeProfilePhotoButtonClicked({required this.newProfilePicture});
}
