import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/chat_contact.dart';
part 'chat_contact_list_event.dart';
part 'chat_contact_list_state.dart';

class ChatContactListBloc
    extends Bloc<ChatContactListEvent, ChatContactListState> {
  final IChatRepository chatRepository;
  ChatContactListBloc({required this.chatRepository})
      : super(ChatContactListLoading()) {
    on<ChatContactListEvent>((event, emit) async {
      emit(ChatContactListLoading());
      if (event is ChatContactListStarted) {
        try {
          final chatContactList = chatRepository.getChatContacts();
          emit(ChatContactListSuccess(chatContactList: chatContactList));
        } on FirebaseException catch (e) {
          emit(ChatContactListError(errorMessage: e.message!));
        }
      }
    });
  }
}
