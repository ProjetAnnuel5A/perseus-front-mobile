import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  const Exercise(this.id, this.name);
  
  Exercise.fromMap(Map<String, dynamic> _map)
      : id = _map['id'] as String,
        name = _map['name'] as String;

  final String id;
  final String name;

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
