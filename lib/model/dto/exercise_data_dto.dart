import 'package:equatable/equatable.dart';

class ExerciseDataDto extends Equatable {
  ExerciseDataDto(this.repetition);

  ExerciseDataDto.fromMap(Map<String, dynamic> _map)
      : repetition = _map['repetition'] as int;

  int repetition;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'repetition': repetition,
      };

  @override
  List<Object?> get props => [
        repetition,
      ];
}
