part of 'mobile_layout_bloc.dart';

@immutable
sealed class MobileLayoutEvent {}

class MobileLayoutStarted extends MobileLayoutEvent {}

class MobileLayoutResumed extends MobileLayoutEvent {}

class MobileLayoutInactiveDetachedPausedHidden extends MobileLayoutEvent {}