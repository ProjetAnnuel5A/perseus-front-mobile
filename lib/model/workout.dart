import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  const Workout(this.name);

  final String name;

  @override
  List<Object?> get props => [
        name,
      ];
}
