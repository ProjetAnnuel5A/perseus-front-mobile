import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/auth/bloc/auth_bloc.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository, this._authenticationBloc)
      : super(LoginInitial()) {
    on<LoginValidateFormEvent>((event, emit) async {
      emit(LoginLoading());

      // TODO add form validation ?

      try {
        final result =
            await _authRepository.login(event.username, event.password);

        _authenticationBloc.add(LoggedIn('username', result!));
      } catch (e) {
        print(e.toString());

        if (e is NotFoundException) {
          emit(LoginError(e.message));
        } else if (e is InternalServerException) {
          emit(LoginError(e.message));
        } else {
          emit(LoginError(ExceptionUnknow().message));
        }
      }
    });
  }

  final AuthBloc _authenticationBloc;
  final AuthRepository _authRepository;
}
