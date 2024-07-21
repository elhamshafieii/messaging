part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainLoading extends MainState {}

final class MainError extends MainState {
  final String errorMessage;

  MainError({required this.errorMessage});
}

final class MainSuccess extends MainState {
  final UserModel? userModel;
  final File defaultWallpaperFile;

  MainSuccess({required this.defaultWallpaperFile, required this.userModel});
}
