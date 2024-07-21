import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final BuildContext context;
  AuthBloc({required this.authRepository, required this.context})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthNextButtonClicked) {
        emit(AuthLoading());
        try {
          final output = await authRepository.signInWithPhone(
              context: context, phoneNumber: event.phoneNumber);
          if (output is User) {
            emit(AuthSuccess(user: output));
          } else if (output is FirebaseAuthException) {
            emit(AuthError(errorMessage: output.message!));
          }
        } on FirebaseAuthException catch (e) {
          emit(AuthError(errorMessage: e.message!));
        }
      }
    });
  }
}
