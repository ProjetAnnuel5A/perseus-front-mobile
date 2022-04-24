import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:perseus_front_mobile/pages/home/bloc/calendar/calendar_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
          create: (BuildContext context) => BottomNavigationBloc(),
        ),
        BlocProvider<CalendarBloc>(
          create: (BuildContext context) => CalendarBloc(),
        ),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  Map<DateTime, List<Workout>> selectedWorkouts = {};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BottomNavigationInitial) {
            return _getHomePageContent(context);
          } else if (state is PageLoaded) {
            if (state.currentIndex == 1) {
              return _getHomePageContent(context);
            } else {
              return const CounterPage();
            }
          }
          return Container();
        },
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          return BottomNavigationBar(
            currentIndex: context.read<BottomNavigationBloc>().currentIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.query_stats),
                label: 'Counter',
              ),
            ],
            onTap: (index) => context.read<BottomNavigationBloc>().add(
                  PageTapped(index: index),
                ),
          );
        },
      ),
    );
  }

  Widget _getHomePageContent(BuildContext context) {
    return Column(
      children: [_getHomeCalendar(context)],
    );
  }

  Widget _getHomeCalendar(BuildContext context) {
    final _calendarBloc = BlocProvider.of<CalendarBloc>(context);

    final _now = _calendarBloc.focusedDay;
    final _firstDay = _now.subtract(const Duration(days: 365));
    final _lastDay = _now.add(const Duration(days: 365));

    selectedWorkouts = _calendarBloc.selectedWorkouts;

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarInitial) {
          return TableCalendar<Workout>(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _now,
            calendarFormat: _calendarBloc.calendarFormat,
            eventLoader: _getEventsfromDay,
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(
                color: ColorPerseus.pink,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            selectedDayPredicate: (DateTime date) {
              return isSameDay(_calendarBloc.selectedDay, date);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_calendarBloc.selectedDay, selectedDay)) {
                print('calendar --> onDaySelected $selectedDay');
                _calendarBloc.add(SelectDay(selectedDay: selectedDay));
              }
            },
            onFormatChanged: (format) {
              if (_calendarBloc.calendarFormat != format) {
                print('calendar --> onFormatChanged $format');
                _calendarBloc.add(UpdateFormat(calendarFormat: format));
              }
            },
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  List<Workout> _getEventsfromDay(DateTime date) {
    var result = <Workout>[];

    selectedWorkouts.forEach((key, workout) {
      if (key.isSameDate(date) && selectedWorkouts[key] != null) {
        result = selectedWorkouts[key]!;
      }
    });

    return result;
  }
}
