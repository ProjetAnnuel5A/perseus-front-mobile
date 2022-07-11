import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/model/dto/offline_dto.dart';
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
              isOffline = true;
              final setCached = Set.fromJson(setJson);

              emit(
                SetLoaded(
                  setCached,
                  isOffline: true,
                ),
              );

              return;
            }
          }
          emit(SetError(e));
        } else {
          emit(SetError(ExceptionUnknown()));
        }
      }
    });

    List<Workout> getCachedWorkouts(
      Box<String> workoutsBox,
    ) {
      final cachedWorkouts = <Workout>[];
      final workoutsJson = workoutsBox.get('data');

      if (workoutsJson == null) {
        return [];
      }

      final data = jsonDecode(workoutsJson) as Map<String, dynamic>;
      final workoutsMap = data['workouts'] as List<dynamic>;

      for (final workoutMapDynamic in workoutsMap) {
        final workoutMap = workoutMapDynamic as Map<String, dynamic>;
        final workout = Workout.fromMap(workoutMap);
        cachedWorkouts.add(workout);
      }

      return cachedWorkouts;
    }

    Future<Set?> validateSetOffline(
      String setId,
      List<Exercise> exercises,
    ) async {
      final workoutsBox = await Hive.openBox<String>('workouts');
      final cachedWorkouts = getCachedWorkouts(workoutsBox);
      var i = 0;
      Set? currentSet;

      for (final cachedWorkout in cachedWorkouts) {
        for (final cachedSet in cachedWorkout.sets) {
          if (cachedSet.id == setId) {
            currentSet = cachedSet.copyWith(
              isValided: true,
              validedAt: DateTime.now(),
              exercises: exercises,
            );

            final sets = cachedWorkout.sets;
            sets[i] = currentSet;

            cachedWorkout.copyWith(sets: sets);

            final data = OfflineDto(cachedWorkouts).toJson();
            // final workoutsJson = jsonEncode(cachedWorkouts);
            await workoutsBox.put('data', data);

            return currentSet;
          }

          i++;
        }
        i = 0;
      }

      return currentSet;
    }

    on<ValidateSet>((event, emit) async {
      emit(SetLoading());
      final setBox = await Hive.openBox<String>('set${set.id}');

      try {
        final set =
            await _setRepository.validateSet(event.setId, event.exercises);
        emit(SetLoaded(set));
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          if (e is CommunicationTimeoutException && setBox.isNotEmpty) {
            final setJson = setBox.get('data');
            if (setJson != null) {
              isOffline = true;

              final cachedSetUpdated =
                  await validateSetOffline(set.id, event.exercises);

              emit(
                SetLoaded(
                  cachedSetUpdated!,
                  isOffline: true,
                ),
              );

              // todo calendarbloc emit started

              return;
            }
          }
          emit(SetError(e));
        } else {
          emit(SetError(ExceptionUnknown()));
        }
      }
    });

    on<IncrementRepetition>((event, emit) async {
      event.set.exercises[event.index].repetition++;

      emit(
        SetLoaded(
          event.set,
          isOffline: isOffline,
        ),
      );
    });

    on<DecrementRepetition>((event, emit) {
      event.set.exercises[event.index].repetition--;

      emit(
        SetLoaded(
          event.set,
          isOffline: isOffline,
        ),
      );
    });

    on<IncrementWeight>((event, emit) {
      event.set.exercises[event.index].weight++;

      emit(
        SetLoaded(
          event.set,
          isOffline: isOffline,
        ),
      );
    });

    on<DecrementWeight>((event, emit) {
      event.set.exercises[event.index].weight--;

      emit(
        SetLoaded(
          event.set,
          isOffline: isOffline,
        ),
      );
    });

    add(SetStarted());
  }

  final WorkoutRepository _workoutRepository;
  final SetRepository _setRepository;

  List<Workout> previousWorkout = [];

  bool isOffline = false;
}
