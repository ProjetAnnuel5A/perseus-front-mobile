import 'package:equatable/equatable.dart';

class ExerciseData extends Equatable {
  ExerciseData(this.id, this.repetition);

  ExerciseData.fromMap(Map<String, dynamic> _map)
      : id = _map['id'] as String,
        repetition = int.parse(_map['repetition'] as String);

  final String id;
  int repetition;

  @override
  List<Object?> get props => [
        id,
        repetition,
      ];
}
