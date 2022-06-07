part of 'set_bloc.dart';

abstract class SetState {
  const SetState();
}

class SetInitial extends SetState {}

class SetLoading extends SetState {}

class SetLoaded extends SetState {
  const SetLoaded(this.set);
  final Set set;
}
