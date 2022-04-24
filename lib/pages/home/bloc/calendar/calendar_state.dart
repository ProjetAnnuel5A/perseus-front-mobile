part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial({
    this.format = CalendarFormat.week,
    required this.selectDay,
  });
  final CalendarFormat format;
  final DateTime selectDay;

  @override
  List<Object> get props => [format, selectDay];
}