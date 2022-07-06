import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._authenticationBloc, this._profileRepository)
      : super(SettingsInitial()) {
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
      _authenticationBloc.add(Logout());
    });

    on<SettingsDeleteAccount>((event, emit) async {
      await _profileRepository.deleteProfile();
      _authenticationBloc.add(Logout());
    });

    add(SettingsStarted());
  }

  final AuthBloc _authenticationBloc;
  final ProfileRepository _profileRepository;
}
