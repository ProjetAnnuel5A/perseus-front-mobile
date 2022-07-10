import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/repositories/set_repository.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';

part 'set_event.dart';
part 'set_state.dart';

class SetBloc extends Bloc<SetEvent, SetState> {
  SetBloc(
    this._setRepository,
    this._workoutRepository,
    Set set,
    DateTime workoutDate,
  ) : super(SetInitial()) {
    on<SetStarted>((event, emit) async {
      emit(SetLoading());
      final setBox = await Hive.openBox<String>('set${set.id}');

      try {
        await set.saveToBox(setBox);

        previousWorkout =
            await _workoutRepository.getAllPreviousByUserId(workoutDate);
        emit(SetLoaded(set));
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          if (e is CommunicationTimeoutException && setBox.isNotEmpty) {
            final setJson = setBox.get('data');
            if (setJson != null) {
              final setCached = Set.fromJson(setJson);
              emit(SetLoaded(setCached));

              return;
            }
          }
          emit(SetError(e));
        } else {
          emit(SetError(ExceptionUnknown()));
        }
      }
    });

    on<ValidateSet>((event, emit) async {
      emit(SetLoading());

      try {
        final set =
            await _setRepository.validateSet(event.setId, event.exercises);
        emit(SetLoaded(set));
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          emit(SetError(e));
        } else {
          emit(SetError(ExceptionUnknown()));
        }
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

  final WorkoutRepository _workoutRepository;
  final SetRepository _setRepository;

  List<Workout> previousWorkout = [];
}
