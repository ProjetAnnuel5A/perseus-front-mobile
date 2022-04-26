import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  const Workout(this.name, this.date);

  Workout.fromMap(Map<String, dynamic> _map)
      : name = _map['name'] as String,
        date = _map['date'] as String;

  final String name;
  final String date;

  Map<String, String> toMap() {
    return {'name': name, 'date': date};
  }

  @override
  List<Object?> get props => [name, date];

  Workout copyWith({String? name, String? date}) {
    return Workout(name ?? this.name, date ?? this.date);
  }
}
