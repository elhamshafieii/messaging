part of 'user_information_bloc.dart';

@immutable
sealed class UserInformationEvent {}
final class UserInformationStatrted extends UserInformationEvent{}

final class UserInformationOkClicked extends UserInformationEvent {
  final String name;
  final File? profilePic;

  UserInformationOkClicked({
    required this.name,
    required this.profilePic,
  });
}
