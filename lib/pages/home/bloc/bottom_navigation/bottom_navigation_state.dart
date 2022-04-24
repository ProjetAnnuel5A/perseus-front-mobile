part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class BottomNavigationInitial extends BottomNavigationState {}

class CurrentIndexChanged extends BottomNavigationState {
  const CurrentIndexChanged({required this.currentIndex}) : super();

  final int currentIndex;
}

class PageLoading extends BottomNavigationState {}

class PageLoaded extends BottomNavigationState {
  const PageLoaded({required this.currentIndex}) : super();

  final int currentIndex;
}
