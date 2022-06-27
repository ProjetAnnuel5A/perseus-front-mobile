import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsStarted>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString('lang');

      if (langCode != null) {
        emit(SettingsLoaded(langCode));
      } else {
        emit(const SettingsLoaded('fr'));
      }
    });

    on<SettingsChangeLanguageEvent>((event, emit) {
      final newLangCode = event.langCode;

      emit(SettingsLoaded(newLangCode));
    });

    add(SettingsStarted());
  }
}
