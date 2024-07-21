part of 'app_bar_mobile_chat_ecreen_bloc.dart';

@immutable
sealed class AppBarMobileChatEcreenState {}

class AppBarMobileChatScreenLoading extends AppBarMobileChatEcreenState {}

class AppBarMobileChatScreenError extends AppBarMobileChatEcreenState {
  final String errorMessage;

  AppBarMobileChatScreenError({required this.errorMessage});
}

class AppBarMobileChatScreenSuccess extends AppBarMobileChatEcreenState {
  final Stream<UserModel> contactUserModelStream;

  AppBarMobileChatScreenSuccess({
    required this.contactUserModelStream,
  });
}
