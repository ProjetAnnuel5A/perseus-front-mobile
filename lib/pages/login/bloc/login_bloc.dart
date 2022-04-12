import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository, this._authenticationBloc)
      : super(LoginInitial()) {
    on<ValidateForm>((event, emit) async {
      final result = await _authRepository.login();

      if (result != null && result != '') {
        _authenticationBloc.add(LoggedIn('username', result));
      }
    });
  }

  final AuthBloc _authenticationBloc;
  final AuthRepository _authRepository;
}
