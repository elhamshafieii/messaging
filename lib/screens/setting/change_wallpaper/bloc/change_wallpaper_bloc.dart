import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:meta/meta.dart';

part 'change_wallpaper_event.dart';
part 'change_wallpaper_state.dart';

class ChangeWallpaperBloc
    extends Bloc<ChangeWallpaperEvent, ChangeWallpaperState> {
  final IChatRepository chatRepository;
  ChangeWallpaperBloc({required this.chatRepository})
      : super(ChangeWallpaperLoading()) {
    on<ChangeWallpaperEvent>((event, emit) async {
      if (event is ChangeWallpaperStrted) {
        try {
          emit(ChangeWallpaperLoading());
          final List<String> lightWallpaperUrls =
              await chatRepository.getWallpapers('light');
          final List<String> darktWallpaperUrls =
              await chatRepository.getWallpapers('dark');
          final List<String> solidWallpaperUrls =
              await chatRepository.getWallpapers('solid');
          emit(ChangeWallpaperSuccess(
              lightWallpaperUrls: lightWallpaperUrls,
              darktWallpaperUrls: darktWallpaperUrls,
              solidWallpaperUrls: solidWallpaperUrls));
        } on FirebaseException catch (e) {
          emit(ChangeWallpaperError(errorMessage: e.message!));
        }
      }
    });
  }
}
