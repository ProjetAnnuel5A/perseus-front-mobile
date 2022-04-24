part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {
  const PageTapped({required this.index}) : super();

  final int index;

  @override
  List<Object> get props => [index];
}
