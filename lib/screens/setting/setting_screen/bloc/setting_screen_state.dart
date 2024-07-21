part of 'setting_screen_bloc.dart';

@immutable
sealed class SettingScreenState {}


final class SettingScreenLoading extends SettingScreenState {}

final class SettingScreenError extends SettingScreenState {
  final String errorMessage;

  SettingScreenError({required this.errorMessage});
}

final class SettingScreenSuccess extends SettingScreenState {
  final UserModel? userModel;

  SettingScreenSuccess({required this.userModel});

}
