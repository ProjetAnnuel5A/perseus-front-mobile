import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthUninitialized()) {
    on<AppStarted>(_appStarted);
    on<LoggedIn>(_loggedIn);
  }

  final _storage = SecureStorage();

  void _appStarted(AuthEvent event, Emitter<AuthState> emit) {
    _cleanUpStorage();
    _initStartup(emit);
  }

  void _loggedIn(LoggedIn event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated());
  }

  Future<void> _initStartup(Emitter<AuthState> emit) async {
    final hasToken = await _storage.hasToken();

    if (!hasToken) {
      emit(AuthUnauthenticated());
      return;
    }

    // TODO! check token etc
    emit(AuthAuthenticated());
  }

  Future<void> _cleanUpStorage() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      await _storage.deleteAll();
      await prefs.setBool('first_run', false);
    }
  }
}