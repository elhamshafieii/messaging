part of 'pop_up_menu_bloc.dart';

@immutable
sealed class PopUpMenuState {}

final class PopUpMenuInitial extends PopUpMenuState {}

final class PopUpMenuLoading extends PopUpMenuState {}

final class PopUpMenuError extends PopUpMenuState {
  final String errorMessage;

  PopUpMenuError({required this.errorMessage});
}

final class PopUpMenuSuccess extends PopUpMenuState {
  PopUpMenuSuccess();
}
