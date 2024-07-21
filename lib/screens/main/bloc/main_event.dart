part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainStarted extends MainEvent{}