part of 'chat_list_bloc.dart';

@immutable
sealed class ChatListEvent {}

class ChatListStarted extends ChatListEvent{}