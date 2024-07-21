part of 'bottom_chat_field_bloc.dart';

@immutable
sealed class BottomChatFieldEvent {}

class BottomChatFieldStarted extends BottomChatFieldEvent {}

class BottomChatFieldSendMessageClicked extends BottomChatFieldEvent {
  final String message;
  final MessageEnum messageEnum;

  BottomChatFieldSendMessageClicked({
    required this.messageEnum,
    required this.message,
  });
}
