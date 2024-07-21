import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/models/user_model.dart';
part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final IChatRepository chatRepository;
  final UserModel contactUserModel;
  ChatListBloc(this.contactUserModel, {required this.chatRepository})
      : super(ChatListLoading()) {
    on<ChatListEvent>((event, emit) async {
      emit(ChatListLoading());
      if (event is ChatListStarted) {
        try {
          final Stream<List<Message>> chatList =
              chatRepository.getChatStream(contactUserModel.uid);
          emit(ChatListSuccess(chatList: chatList));
        } on FirebaseException catch (e) {
          emit(ChatListError(errorMessage: e.message!));
        }
      }
    });
  }
}
