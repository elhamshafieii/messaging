part of 'change_wallpaper_bloc.dart';

@immutable
sealed class ChangeWallpaperState {}

final class ChangeWallpaperLoading extends ChangeWallpaperState {}

final class ChangeWallpaperError extends ChangeWallpaperState {
  final String errorMessage;

  ChangeWallpaperError({required this.errorMessage});
}

final class ChangeWallpaperSuccess extends ChangeWallpaperState {
  final List<String> lightWallpaperUrls;
  final List<String> darktWallpaperUrls;
  final List<String> solidWallpaperUrls;

  ChangeWallpaperSuccess(
      {required this.lightWallpaperUrls,
      required this.darktWallpaperUrls,
      required this.solidWallpaperUrls});
}
