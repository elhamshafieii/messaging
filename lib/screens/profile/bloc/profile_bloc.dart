import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String uid;

  final IChatRepository chatRepository;
  ProfileBloc({
    required this.uid,
    required this.chatRepository,
  }) : super(ProfileLoading()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStarted) {
        try {
          final userModelStream = chatRepository.getUserModelStream(uid);
          emit(ProfileSuccess(userModelStream: userModelStream));
        } on FirebaseException catch (e) {
          emit(ProfileError(errorMessage: e.toString()));
        }
      }
    });
  }
}
