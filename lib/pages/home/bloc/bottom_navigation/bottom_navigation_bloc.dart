import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationInitial()) {
    on<PageTapped>((event, emit) {
      if (event.index != currentIndex) {
        currentIndex = event.index;
        emit(CurrentIndexChanged(currentIndex: currentIndex));
        emit(PageLoading());
        emit(PageLoaded(currentIndex: currentIndex));
      }
    });
  }

  // default to 1 for home page
  int currentIndex = 1;
}
