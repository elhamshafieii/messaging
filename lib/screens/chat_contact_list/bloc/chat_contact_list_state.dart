part of 'chat_contact_list_bloc.dart';

@immutable
sealed class ChatContactListState {}

final class ChatContactListLoading extends ChatContactListState {}

final class ChatContactListSuccess extends ChatContactListState {
  final Stream<List<ChatContact>> chatContactList;
  ChatContactListSuccess({required this.chatContactList});
}

final class ChatContactListError extends ChatContactListState {
  final String errorMessage;

  ChatContactListError({required this.errorMessage});
}
