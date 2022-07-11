import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/dto/offline_dto.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(this._workoutRepository) : super(CalendarInitial()) {
    on<CalendarStarted>(_onStarted);

    // use copyWith?

    on<UpdateFormat>((event, emit) {
      calendarFormat = event.calendarFormat;
      emit(
        CalendarLoaded(
          workouts: workouts,
          format: calendarFormat,
          selectDay: selectedDay,
          isOffline: isOffline,
        ),
      );
    });

    on<SelectDay>((event, emit) {
      selectedDay = event.selectedDay;
      focusedDay = event.selectedDay;

      emit(
        CalendarLoaded(
          workouts: workouts,
          format: calendarFormat,
          selectDay: selectedDay,
          isOffline: isOffline,
        ),
      );
    });

    on<ValidateWorkout>((event, emit) async {
      emit(CalendarLoading());
      final workoutsBox = await Hive.openBox<String>('workouts');

      try {
        await _workoutRepository.validateWorkout(event.workoutId);
        add(CalendarStarted());
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          if (e is CommunicationTimeoutException && workoutsBox.isNotEmpty) {
            isOffline = true;
            final cachedWorkouts = getCachedWorkouts(workoutsBox);

            for (var i = 0; i < cachedWorkouts.length; i++) {
              if (cachedWorkouts[i].id == event.workoutId) {
                cachedWorkouts[i] = cachedWorkouts[i].copyWith(isValided: true);
                for (var y = 0; y < cachedWorkouts[i].sets.length; y++) {
                  if (!cachedWorkouts[i].sets[y].isValided) {
                    cachedWorkouts[i].sets[y] =
                        cachedWorkouts[i].sets[y].copyWith(
                              isValided: true,
                              validedAt: DateTime.now(),
                            );
                  }
                }

                final data = OfflineDto(cachedWorkouts).toJson();
                await workoutsBox.put('data', data);

                emit(
                  CalendarLoaded(
                    workouts: cachedWorkouts,
                    selectDay: DateTime.now(),
                    isOffline: true,
                  ),
                );

                return;
              }
            }

            emit(
              CalendarLoaded(
                workouts: cachedWorkouts,
                selectDay: DateTime.now(),
                isOffline: true,
              ),
            );

            return;
          }
          emit(CalendarError(e));
        } else {
          emit(CalendarError(ExceptionUnknown()));
        }
      }
    });

    on<UpdateWorkoutsRequested>((event, emit) async {
      emit(CalendarLoading());
      final workoutsBox = await Hive.openBox<String>('workouts');

      try {
        workouts = await _workoutRepository.getAllByUserId();
        emit(CalendarLoaded(workouts: workouts, selectDay: selectedDay));
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          if (e is CommunicationTimeoutException && workoutsBox.isNotEmpty) {
            isOffline = true;
            final cachedWorkouts = getCachedWorkouts(workoutsBox);

            emit(
              CalendarLoaded(
                workouts: cachedWorkouts,
                selectDay: DateTime.now(),
                isOffline: true,
              ),
            );

            return;
          }
          emit(CalendarError(e));
        } else {
          emit(CalendarError(ExceptionUnknown()));
        }
      }
    });

    on<SaveOfflineWorkouts>((event, emit) async {
      emit(CalendarLoading());
      final workoutsBox = await Hive.openBox<String>('workouts');

      try {
        final cachedWorkouts = getCachedWorkouts(workoutsBox);
        // final workoutsJson = workoutsBox.get('data');
        final workouts =
            await _workoutRepository.saveOfflineWorkouts(cachedWorkouts);

        isOffline = false;
        emit(CalendarLoaded(workouts: workouts, selectDay: selectedDay));
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
          emit(CalendarError(e));
        } else {
          emit(CalendarError(ExceptionUnknown()));
        }
      }
    });

    on<ReloadCache>((event, emit) async {
      emit(CalendarLoading());
      final workoutsBox = await Hive.openBox<String>('workouts');

      try {
        final cachedWorkouts = getCachedWorkouts(workoutsBox);
        isOffline = true;
        emit(
          CalendarLoaded(
            workouts: cachedWorkouts,
            selectDay: selectedDay,
            isOffline: true,
          ),
        );
      } catch (e) {
        if (e is HttpException) {
          emit(CalendarError(e));
        } else {
          emit(CalendarError(ExceptionUnknown()));
        }
      }
    });

    initializeSocket();

    add(CalendarStarted());
  }

  Future<void> _onStarted(
    CalendarStarted event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    isOffline = false;

    final workoutsBox = await Hive.openBox<String>('workouts');

    // Initialize calendar values
    final _now = DateTime.now();

    focusedDay = _now;
    selectedDay = _now;
    firstDay = _now.subtract(const Duration(days: 365));
    lastDay = _now.add(const Duration(days: 365));

    try {
      workouts = await _workoutRepository.getAllByUserId();
      await saveWorkoutsToBox(workouts, workoutsBox);

      emit(CalendarLoaded(workouts: workouts, selectDay: DateTime.now()));
    } catch (e) {
      // print(e.toString());

      if (e is HttpException) {
        if (e is CommunicationTimeoutException && workoutsBox.isNotEmpty) {
          isOffline = true;

          final cachedWorkouts = getCachedWorkouts(workoutsBox);

          emit(
            CalendarLoaded(
              workouts: cachedWorkouts,
              selectDay: DateTime.now(),
              isOffline: true,
            ),
          );

          return;
        }
        emit(CalendarError(e));
      } else {
        emit(CalendarError(ExceptionUnknown()));
      }
    }
  }

  @override
  Future<void> close() async {
    _socket.dispose();
    return super.close();
  }

  Future<void> initializeSocket() async {
    final userId = await SecureStorage().getUserId();

    final server = dotenv.env['sport_api'] ?? 'http://127.0.0.1:3000';
    _socket = io('$server/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket
      ..connect()
      ..on('event-validate-set/$userId', (dynamic data) async {
        if (state is CalendarLoaded) {
          add(CalendarStarted());
        }
      })
      ..on('event-generate-program/$userId', (dynamic data) async {
        if (state is CalendarLoaded) {
          add(const UpdateWorkoutsRequested());
        }
      });
  }

  Future<void> saveWorkoutsToBox(
    List<Workout> workouts,
    Box<String> workoutsBox,
  ) async {
    final workoutsJson = OfflineDto(workouts).toJson();
    await workoutsBox.put('data', workoutsJson);
  }

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

    workouts = cachedWorkouts;

    return cachedWorkouts;
  }

  late final Socket _socket;

  final WorkoutRepository _workoutRepository;

  CalendarFormat calendarFormat = CalendarFormat.week;

  /// DateTime that determines which days are currently visible and focused.
  DateTime focusedDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// Signature for `onDaySelected` callback.
  /// Contains the selected day and focused day.
  DateTime selectedDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// The first active day of `TableCalendar`.
  DateTime firstDay = DateTime.fromMillisecondsSinceEpoch(0);

  /// The last active day of `TableCalendar`.
  DateTime lastDay = DateTime.fromMillisecondsSinceEpoch(0);

  List<Workout> workouts = [];

  bool isOffline = false;
}
