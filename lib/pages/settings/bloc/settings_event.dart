part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsStarted extends SettingsEvent {}

class SettingsDeleteAccount extends SettingsEvent {}
class SettingsChangeLanguageEvent extends SettingsEvent {
  const SettingsChangeLanguageEvent(this.langCode);

  final String langCode;
}
