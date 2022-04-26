import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/theme/colors.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/model/workout.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:perseus_front_mobile/pages/home/bloc/calendar/calendar_bloc.dart';
import 'package:perseus_front_mobile/repositories/workout_repository.dart';
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
          create: (BuildContext context) =>
              CalendarBloc(context.read<WorkoutRepository>()),
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
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.verified_user),
                label: 'Profile',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                  badgeContent:
                      const Text('3', style: TextStyle(color: Colors.white)),
                  child: const Icon(Icons.notifications),
                ),
                label: 'Notification',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Reglage',
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
      children: [_getHomeCalendar(context), _getWorkouts()],
    );
  }

  Widget _getHomeCalendar(BuildContext context) {
    final _calendarBloc = BlocProvider.of<CalendarBloc>(context);

    final _now = _calendarBloc.focusedDay;
    final _firstDay = _now.subtract(const Duration(days: 365));
    final _lastDay = _now.add(const Duration(days: 365));

    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarLoaded) {
          //TODO change it with workout Date
          selectedWorkouts = {_now: _calendarBloc.workouts};

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
                print(_getEventsfromDay(selectedDay));
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

        return const Center(
          child: CircularProgressIndicator(),
        );
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

  Widget _getWorkouts() {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        if (state is CalendarLoaded) {
          return Text('Workouts: ${state.workouts}');
        }

        return const CircularProgressIndicator();
      },
    );
    // return Card(
    //   child:
    //       SizedBox(height: 200, width: double.infinity, child: Text('fezrf')),
    // );

    //   return Card(
    //     clipBehavior: Clip.antiAlias,
    //     child: Column(
    //       children: [
    //         ListTile(
    //           leading: Icon(Icons.arrow_drop_down_circle),
    //           title: const Text('Card title 1'),
    //           subtitle: Text(
    //             'Secondary Text',
    //             style: TextStyle(color: Colors.black.withOpacity(0.6)),
    //           ),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(
    //             'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
    //             style: TextStyle(color: Colors.black.withOpacity(0.6)),
    //           ),
    //         ),
    //         ButtonBar(
    //           alignment: MainAxisAlignment.start,
    //           children: [
    //             FlatButton(
    //               textColor: const Color(0xFF6200EE),
    //               onPressed: () {
    //                 // Perform some action
    //               },
    //               child: const Text('ACTION 1'),
    //             ),
    //             FlatButton(
    //               textColor: const Color(0xFF6200EE),
    //               onPressed: () {
    //                 // Perform some action
    //               },
    //               child: const Text('ACTION 2'),
    //             ),
    //           ],
    //         ),
    //         // Image.network('http://via.placeholder.com/640x360'),
    //         Image.asset('/images/640x360.png'),
    //         // Image.asset('http://via.placeholder.com/640x360'),
    //       ],
    //     ),
    //   );
    // }
  }
}
