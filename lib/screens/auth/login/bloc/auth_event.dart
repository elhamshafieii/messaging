part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}
final class AuthNextButtonClicked extends AuthEvent {
  final String phoneNumber;

  AuthNextButtonClicked({required this.phoneNumber});
}

