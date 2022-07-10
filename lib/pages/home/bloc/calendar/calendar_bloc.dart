import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
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
        ),
      );
    });

    on<ValidateWorkout>((event, emit) async {
      emit(CalendarLoading());

      try {
        await _workoutRepository.validateWorkout(event.workoutId);
        add(CalendarStarted());
      } catch (e) {
        // print(e.toString());

        if (e is HttpException) {
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
            final cachedWorkouts = getCachedWorkouts(workoutsBox);

            workouts = cachedWorkouts;

            emit(
              CalendarLoaded(
                workouts: cachedWorkouts,
                selectDay: DateTime.now(),
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

    initializeSocket();

    add(CalendarStarted());
  }

  Future<void> _onStarted(
    CalendarStarted event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());

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
          final cachedWorkouts = getCachedWorkouts(workoutsBox);

          workouts = cachedWorkouts;

          emit(
            CalendarLoaded(workouts: cachedWorkouts, selectDay: DateTime.now()),
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
    final workoutsJson = jsonEncode(workouts);
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

    final workoutsMap = jsonDecode(workoutsJson) as List<dynamic>;

    for (final workoutJson in workoutsMap) {
      final workoutMap =
          json.decode(workoutJson as String) as Map<String, dynamic>;
      final workout = Workout.fromMapJson(workoutMap);
      cachedWorkouts.add(workout);
    }

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
}
