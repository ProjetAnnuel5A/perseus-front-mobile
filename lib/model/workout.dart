import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/model/set.dart';

class Workout extends Equatable {
  const Workout(
    this.id,
    this.name,
    this.estimatedTime,
    this.date,
    this.sets,
    this.validedAt,
    this.createdAt,
    this.updatedAt, {
    required this.isValided,
  });

  factory Workout.fromMap(Map<String, dynamic> _map) {
    final sets = <Set>[];
    final setsMap = _map['sets'] as List<dynamic>;

    for (final set in setsMap) {
      sets.add(Set.fromMap(set as Map<String, dynamic>));
    }

    return Workout(
      _map['id'] as String,
      _map['name'] as String,
      _map['estimatedTime'] as int,
      DateTime.parse(_map['date'] as String),
      sets,
      _map['validedAt'] != null
          ? DateTime.parse(_map['validedAt'] as String)
          : null,
      DateTime.parse(_map['createdAt'] as String),
      DateTime.parse(_map['updatedAt'] as String),
      isValided: _map['isValided'] as bool,
    );
  }

  final String id;
  final String name;
  final int estimatedTime;
  final DateTime date;
  final bool isValided;
  final List<Set> sets;

  final DateTime? validedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout copyWith({
    String? id,
    String? name,
    int? estimatedTime,
    DateTime? date,
    bool? isValided,
    List<Set>? sets,
    DateTime? validedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workout(
      id ?? this.id,
      name ?? this.name,
      estimatedTime ?? this.estimatedTime,
      date ?? this.date,
      sets ?? this.sets,
      validedAt ?? this.validedAt,
      createdAt ?? this.createdAt,
      updatedAt ?? this.updatedAt,
      isValided: isValided ?? this.isValided,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'estimatedTime': estimatedTime,
      'date': date.millisecondsSinceEpoch,
      'isValided': isValided,
      'sets': sets,
      'validedAt': validedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      estimatedTime,
      date,
      isValided,
      sets,
      createdAt,
      updatedAt,
    ];
  }
}
