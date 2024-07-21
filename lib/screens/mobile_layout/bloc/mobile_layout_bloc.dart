import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/auth_repository.dart';
part 'mobile_layout_event.dart';
part 'mobile_layout_state.dart';

class MobileLayoutBloc extends Bloc<MobileLayoutEvent, MobileLayoutState> {
  final IAuthRepository authRepository;
  MobileLayoutBloc({required this.authRepository})
      : super(MobileLayoutInitial()) {
    on<MobileLayoutEvent>((event, emit) async {
      if (event is MobileLayoutResumed) {
        emit(MobileLayoutChangeUserOnlineStatusLoading());
        try {
          await authRepository.setUserStatus(true);

          emit(MobileLayoutChangeUserOnlineStatusSuccess());
        } on FirebaseException catch (e) {
          emit(MobileLayoutChangeUserOnlineStatusError(
              errorMessage: e.toString()));
        }
      } else if (event is MobileLayoutInactiveDetachedPausedHidden) {
        emit(MobileLayoutChangeUserOnlineStatusLoading());
        try {
          await authRepository.setUserStatus(false);

          emit(MobileLayoutChangeUserOnlineStatusSuccess());
        } on FirebaseException catch (e) {
          emit(MobileLayoutChangeUserOnlineStatusError(
              errorMessage: e.toString()));
        }
      }
    });
  }
}
