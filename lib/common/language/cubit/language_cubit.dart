import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  Future<void> getStartingLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('lang');

    if (langCode != null) {
      emit(Locale(langCode));
    }
  }

  Future<void> changeLang(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', data);

    print('changeLang --> $data');

    emit(Locale(data));
  }
}
