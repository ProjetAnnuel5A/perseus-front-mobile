import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository, this._authenticationBloc)
      : super(LoginInitial()) {
    on<LoginUsernameChangedEvent>((event, emit) async {
      print(event.username);
    });

    on<LoginValidateFormEvent>((event, emit) async {
      print(event.username);
      print(event.password);

      //! TODO add form validation

      final result =
          await _authRepository.login(event.username, event.password);

      if (result != null && result != '') {
        _authenticationBloc.add(LoggedIn('username', result));
      }
    });
  }

  final AuthBloc _authenticationBloc;
  final AuthRepository _authRepository;
}
