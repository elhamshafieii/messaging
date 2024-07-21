part of 'chat_contact_list_bloc.dart';

@immutable
sealed class ChatContactListEvent {}

class ChatContactListStarted extends ChatContactListEvent{}
