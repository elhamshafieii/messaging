import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/common/enums/message_enum.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
part 'bottom_chat_field_event.dart';
part 'bottom_chat_field_state.dart';

class BottomChatFieldBloc
    extends Bloc<BottomChatFieldEvent, BottomChatFieldState> {
  final IChatRepository chatRepository;
  final IAuthRepository authRepository;
  final UserModel contactUserModel;
  BottomChatFieldBloc(
      {required this.contactUserModel,
      required this.authRepository,
      required this.chatRepository})
      : super(BottomChatFieldInitial()) {
    on<BottomChatFieldEvent>((event, emit) async {
      emit(BottomChatFieldSendMessageClickedLoading());
      if (event is BottomChatFieldSendMessageClicked) {
        try {
          final UserModel? senderUserData =
              await authRepository.getCurrentUserData();
          await chatRepository.sendMessage(
              contactUserModel: contactUserModel,
              userModel: senderUserData!,
              messageEnum: event.messageEnum,
              message: event.message);
          emit(BottomChatFieldSendMessageClickedSuccess());
        } on FirebaseException catch (e) {
          emit(BottomChatFieldSendMessageClickedError(
            errorMessage: e.message.toString(),
          ));
        }
      }
    });
  }
}
