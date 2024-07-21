part of 'select_contact_bloc.dart';

@immutable
sealed class SelectContactState {}

final class SelectContactInitial extends SelectContactState {}

class SelectContactLoading extends SelectContactState {}

class SelectContactError extends SelectContactState {
  final String errorMessage;

  SelectContactError({required this.errorMessage});
}

class SelectContactSuccess extends SelectContactState {
  final UserModel contactUserModel;

  SelectContactSuccess({required this.contactUserModel});
}
