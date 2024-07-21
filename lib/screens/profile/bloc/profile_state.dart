part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}



class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}

class ProfileSuccess extends ProfileState {
  final Stream<UserModel> userModelStream;

  ProfileSuccess({
    required this.userModelStream,
  });
}



