import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';
part 'change_profile_setting_dialog_event.dart';
part 'change_profile_setting_dialog_state.dart';

class ChangeProfileSettingDialogBloc extends Bloc<
    ChangeProfileSettingDialogEvent, ChangeProfileSettingDialogState> {
  final IAuthRepository authRepository;
  ChangeProfileSettingDialogBloc({required this.authRepository})
      : super(ChangeProfileSettingDialogInitial()) {
    on<ChangeProfileSettingDialogEvent>((event, emit) async {
      if (event is ChangeProfileSettingDialogSaveButtonClicked) {
        try {
          await authRepository.changeUserDataInFirebase(event.newUserModel);
          emit(
              ChangeProfileSettingDialogSuccess(userModel: event.newUserModel));
        } on FirebaseException catch (e) {
          emit(ChangeProfileSettingDialogError(errorMessage: e.toString()));
        }
      }
    });
  }
}
