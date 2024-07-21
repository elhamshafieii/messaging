import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';

part 'user_information_event.dart';
part 'user_information_state.dart';

class UserInformationBloc
    extends Bloc<UserInformationEvent, UserInformationState> {
  final IAuthRepository authRepository;
  UserInformationBloc({required this.authRepository})
      : super(UserInformationInitial()) {
    on<UserInformationEvent>((event, emit) async {
      if (event is UserInformationOkClicked) {
        emit(UserInformationLoading());
        try {
          final UserModel userModel = await authRepository
              .saveUserDataToFirebase(event.name, event.profilePic);
          emit(UserInformationSuccess(userModel: userModel));
        } on FirebaseException catch (e) {
          emit(UserInformationError(errorMessage: e.message!));
        }
      }
    });
  }
}
