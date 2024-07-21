import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:messaging/data/repository/select_contact_repository.dart';
import 'package:messaging/models/user_model.dart';
part 'select_contact_event.dart';
part 'select_contact_state.dart';

class SelectContactBloc extends Bloc<SelectContactEvent, SelectContactState> {
  final ISelectContactRepository selectContactRepository;
  SelectContactBloc({required this.selectContactRepository})
      : super(SelectContactInitial()) {
    on<SelectContactEvent>((event, emit) async {
      emit(SelectContactLoading());
      if (event is SelectContactStarted) {
        try {
          final contactUserModel = await selectContactRepository
              .selectContact(event.selectedContact);
          if (contactUserModel != null) {
            emit(SelectContactSuccess(contactUserModel: contactUserModel));
          } else {
            emit(SelectContactError(
                errorMessage:
                    'This contact does not exist  this application ...'));
          }
        } on FirebaseAuthException catch (e) {
          emit(SelectContactError(errorMessage: e.toString()));
        }
      }
    });
  }
}
