import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'pop_up_menu_event.dart';
part 'pop_up_menu_state.dart';

class PopUpMenuBloc extends Bloc<PopUpMenuEvent, PopUpMenuState> {
  final IAuthRepository authRepository;
  PopUpMenuBloc({required this.authRepository}) : super(PopUpMenuInitial()) {
    on<PopUpMenuEvent>((event, emit) async {
      if (event is PopUpMenuExitClicked) {
        try {
          emit(PopUpMenuLoading());
          await authRepository.signOut();
          emit(PopUpMenuSuccess());
        } on FirebaseException catch (e) {
          emit(PopUpMenuError(errorMessage: e.message!));
        }
      }
    });
  }
}
