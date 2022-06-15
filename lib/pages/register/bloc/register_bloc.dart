import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/model/dto/register_dto.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<RegisterValidateFormEvent>((event, emit) async {
      emit(RegisterLoading());

      try {
        final _ = await _authRepository
            .register(RegisterDto(event.username, event.email, event.password));

        emit(RegisterSuccess());
      } catch (e) {
        print(e.toString());

        if (e is NotFoundException) {
          emit(RegisterError(e.message));
        } else if (e is ConflictException) {
          emit(RegisterError(e.message));
        } else {
          emit(RegisterError(ExceptionUnknow().message));
        }
      }
    });
  }

  final AuthRepository _authRepository;
}
