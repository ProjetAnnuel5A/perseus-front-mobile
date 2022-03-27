import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/repositories/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<ValidateForm>((event, emit) async {
      final result = await _authRepository.register();
    });
  }

  final AuthRepository _authRepository;
}
