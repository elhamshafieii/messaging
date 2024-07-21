import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:meta/meta.dart';

part 'app_bar_mobile_chat_ecreen_event.dart';
part 'app_bar_mobile_chat_ecreen_state.dart';

class AppBarMobileChatEcreenBloc extends Bloc<AppBarMobileChatEcreenEvent, AppBarMobileChatEcreenState> {
    final IChatRepository chatRepository;
  final String uid;
  AppBarMobileChatEcreenBloc({required this.chatRepository, required this.uid}) : super(AppBarMobileChatScreenLoading()) {
    on<AppBarMobileChatEcreenEvent>((event, emit) {
        emit(AppBarMobileChatScreenLoading());
      if (event is AppBarMobileChatScreenStarted) {
        try {
          final contactUserModelStream =
              chatRepository.getUserModelStream(uid);
          emit(AppBarMobileChatScreenSuccess(
              contactUserModelStream: contactUserModelStream));
        } on FirebaseException catch (e) {
          emit(AppBarMobileChatScreenError(errorMessage: e.toString()));
        }
      }
    });
  }
}
