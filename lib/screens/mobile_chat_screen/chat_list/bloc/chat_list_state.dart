part of 'chat_list_bloc.dart';

@immutable
sealed class ChatListState {}



final class ChatListLoading extends ChatListState {}

final class ChatListSuccess extends ChatListState {
  final Stream<List<Message>> chatList;
  ChatListSuccess({required this.chatList});
}

final class ChatListError extends ChatListState {
  final String errorMessage;

  ChatListError({required this.errorMessage});
}
