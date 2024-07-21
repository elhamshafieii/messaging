import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:meta/meta.dart';

part 'change_profile_photo_event.dart';
part 'change_profile_photo_state.dart';

class ChangeProfilePhotoBloc
    extends Bloc<ChangeProfilePhotoEvent, ChangeProfilePhotoState> {
  final UserModel userModel;
  final IAuthRepository authRepository;
  ChangeProfilePhotoBloc(
      {required this.userModel, required this.authRepository})
      : super(ChangeProfilePhotoInitial()) {
    on<ChangeProfilePhotoEvent>((event, emit) async {
      if (event is ChangeProfilePhotoButtonClicked) {
        emit(ChangeProfileSettingLoading());
        try {
          final newUserModel = await authRepository.saveUserDataToFirebase(
              userModel.name, event.newProfilePicture);
          emit(ChangeProfileSettingSuccess(newUserModel: newUserModel));
        } on FirebaseException catch (e) {
          emit(ChangeProfileSettingError(errorMessage: e.toString()));
        }
      }
    });
  }
}
