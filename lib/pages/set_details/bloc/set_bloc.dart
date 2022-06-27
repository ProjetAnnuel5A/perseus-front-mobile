import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';
import 'package:perseus_front_mobile/repositories/set_repository.dart';

part 'set_event.dart';
part 'set_state.dart';

class SetBloc extends Bloc<SetEvent, SetState> {
  SetBloc(this._setRepository, String setId) : super(SetInitial()) {
    on<SetStarted>((event, emit) async {
      final set = await _setRepository.getById(setId);

      if (set != null) {
        emit(SetLoaded(set));
      } else {
        // error state
      }
    });

    on<ValidateSet>((event, emit) async {
      emit(SetLoading());

      final set =
          await _setRepository.validateSet(event.setId, event.exercises);

      if (set != null) {
        emit(SetLoaded(set));
      } else {
        // error state
      }
    });

    on<IncrementRepetition>((event, emit) {
      event.set.exercises[event.index].repetition++;

      emit(
        SetLoaded(
          event.set,
        ),
      );
    });

    on<DecrementRepetition>((event, emit) {
      event.set.exercises[event.index].repetition--;

      emit(
        SetLoaded(
          event.set,
        ),
      );
    });

    on<IncrementWeight>((event, emit) {
      event.set.exercises[event.index].weight++;

      emit(
        SetLoaded(
          event.set,
        ),
      );
    });

    on<DecrementWeight>((event, emit) {
      event.set.exercises[event.index].weight--;

      emit(
        SetLoaded(
          event.set,
        ),
      );
    });

    add(SetStarted());
  }

  final SetRepository _setRepository;
}
