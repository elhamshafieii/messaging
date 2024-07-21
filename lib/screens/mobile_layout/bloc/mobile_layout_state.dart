part of 'mobile_layout_bloc.dart';

@immutable
sealed class MobileLayoutState {}

final class MobileLayoutInitial extends MobileLayoutState {}

class MobileLayoutChangeUserOnlineStatusError extends MobileLayoutState {
  final String errorMessage;

  MobileLayoutChangeUserOnlineStatusError({required this.errorMessage});
}

class MobileLayoutChangeUserOnlineStatusSuccess extends MobileLayoutState {

  MobileLayoutChangeUserOnlineStatusSuccess();
}

class MobileLayoutChangeUserOnlineStatusLoading extends MobileLayoutState {}
