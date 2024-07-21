part of 'bottom_chat_field_bloc.dart';

@immutable
sealed class BottomChatFieldState {}

final class BottomChatFieldInitial extends BottomChatFieldState {}

class BottomChatFieldSendMessageClickedLoading extends BottomChatFieldState {
  BottomChatFieldSendMessageClickedLoading();
}

class BottomChatFieldSendMessageClickedError extends BottomChatFieldState {
  final String errorMessage;

  BottomChatFieldSendMessageClickedError({required this.errorMessage});
}

class BottomChatFieldSendMessageClickedSuccess extends BottomChatFieldState {}
