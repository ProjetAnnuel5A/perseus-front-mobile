import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perseus_front_mobile/l10n/l10n.dart';
import 'package:perseus_front_mobile/pages/counter/counter.dart';
import 'package:perseus_front_mobile/pages/home/bloc/bottom_navigation_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (BuildContext context, BottomNavigationState state) {
          if (state is PageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BottomNavigationInitial) {
            return _getHomePageContent();
          } else if (state is PageLoaded) {
            if (state.currentIndex == 0) {
              return _getHomePageContent();
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

  Widget _getHomePageContent() {
    return const Center(
      child: Text('Home page'),
    );
  }
}
