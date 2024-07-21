part of 'select_contact_bloc.dart';

@immutable
sealed class SelectContactEvent {}

class SelectContactStarted extends SelectContactEvent {
  final Contact selectedContact;
  SelectContactStarted({required this.selectedContact});
}
