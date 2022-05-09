import 'package:equatable/equatable.dart';

class ExerciseData extends Equatable {
  const ExerciseData(this.id, this.repetition);

  ExerciseData.fromMap(Map<String, dynamic> _map)
      : id = _map['id'] as String,
        repetition = _map['repetition'] as int;

  final String id;
  final int repetition;

  @override
  List<Object?> get props => [
        id,
        repetition,
      ];
}
