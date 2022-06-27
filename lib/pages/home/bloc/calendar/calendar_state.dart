part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded({
    this.workouts = const [],
    this.format = CalendarFormat.week,
    required this.selectDay,
  });
  final List<Workout> workouts;

  final CalendarFormat format;
  final DateTime selectDay;

  @override
  List<Object> get props => [workouts, format, selectDay];
}

class CalendarError extends CalendarState {
  const CalendarError(this.httpException);
  final HttpException httpException;
}
