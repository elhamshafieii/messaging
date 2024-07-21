part of 'user_information_bloc.dart';

@immutable
sealed class UserInformationState {}

final class UserInformationInitial extends UserInformationState {}

final class UserInformationLoading extends UserInformationState {}

final class UserInformationSuccess extends UserInformationState {
  final UserModel userModel;
  UserInformationSuccess({required this.userModel});
}

final class UserInformationError extends UserInformationState {
  final String errorMessage;

  UserInformationError({required this.errorMessage});
}
