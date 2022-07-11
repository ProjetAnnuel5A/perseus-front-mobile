part of 'set_bloc.dart';

abstract class SetState {
  const SetState();
}

class SetInitial extends SetState {}

class SetLoading extends SetState {}

class SetLoaded extends SetState {
  SetLoaded(
    this.set, {
    this.isOffline = false,
  });
  
  final Set set;
  bool isOffline;
}

class SetError extends SetState {
  const SetError(this.httpException);
  final HttpException httpException;
}
