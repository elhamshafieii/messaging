import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/models/user_model.dart';
import 'package:meta/meta.dart';

part 'setting_screen_event.dart';
part 'setting_screen_state.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingScreenState> {
  final IAuthRepository authRepository;
  SettingScreenBloc({required this.authRepository})
      : super(SettingScreenLoading()) {
    on<SettingScreenEvent>((event, emit) async {
      if (event is SettingScreenStarted) {
        emit(SettingScreenLoading());
        try {
          final UserModel? userModel =
              await authRepository.getCurrentUserData();
          emit(SettingScreenSuccess(userModel: userModel));
        } on FirebaseException catch (e) {
          emit(SettingScreenError(errorMessage: e.message!));
        }
      }
    });
  }
}
