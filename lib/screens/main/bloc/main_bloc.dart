import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final IAuthRepository authRepository;
  final IChatRepository chatRepository;
  MainBloc({required this.chatRepository, required this.authRepository})
      : super(MainLoading()) {
    on<MainEvent>((event, emit) async {
      if (event is MainStarted) {
        try {
          emit(MainLoading());
          final UserModel? userModel =
              await authRepository.getCurrentUserData();
          final defaultWallpaperUrl =
              await chatRepository.getDefaultWallPaper();
          final defaultWallpaperFile =
              await DefaultCacheManager().getSingleFile(defaultWallpaperUrl);
          emit(MainSuccess(
              userModel: userModel,
              defaultWallpaperFile: defaultWallpaperFile));
        } on FirebaseException catch (e) {
          emit(MainError(errorMessage: e.message!));
        }
      }
    });
  }
}
