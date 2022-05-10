import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthUninitialized()) {
    on<AppStarted>(_appStarted);
    on<LoggedIn>(_loggedIn);
    on<Logout>(_logout);
  }

  final _storage = SecureStorage();

  // ignore: avoid_void_async
  void _appStarted(AuthEvent event, Emitter<AuthState> emit) async {
    await _cleanUpStorage();
    await _initStartup(emit);
  }

  void _loggedIn(LoggedIn event, Emitter<AuthState> emit) {
    _storage.saveUsernameAndToken(event.username, event.token);

    emit(AuthAuthenticated());
  }

  void _logout(Logout event, Emitter<AuthState> emit) {
    _storage.deleteAll();
    emit(AuthUnauthenticated());
  }

  Future<void> _initStartup(Emitter<AuthState> emit) async {
    final hasToken = await _storage.hasToken();

    if (!hasToken) {
      emit(AuthUnauthenticated());
      return;
    }

    final token = await _storage.getToken();

    if (token == null) {
      emit(AuthUnauthenticated());
      return;
    }

    if (JwtDecoder.tryDecode(token) == null || JwtDecoder.isExpired(token)) {
      emit(AuthUnauthenticated());
      await _storage.deleteAll();

      return;
    }

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
