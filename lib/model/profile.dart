// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/model/enum/level.dart';
import 'package:perseus_front_mobile/model/enum/objective.dart';

class Profile extends Equatable {
  Profile(
    this.id,
    this.email,
    this.username,
    this.birthDate,
    this.height,
    this.weight,
    this.availability,
    this.objective,
    this.level,
  );
  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Profile.fromMap(Map<String, dynamic> map) {
    DateTime? birthDate = DateTime.now();
    var objective = Objective.GAIN;
    var level = Level.INTERMEDIATE;

    if (map['birthDate'] != null) {
      birthDate = DateTime.parse(map['birthDate'] as String);
    }

    if (map['objective'] != null) {
      final objectiveStr = map['objective'] as String;
      objective = Objective.values.firstWhere(
        (e) => e.toString() == 'Objective.$objectiveStr',
      );
    }

    if (map['level'] != null) {
      final levelStr = map['level'] as String;
      level = Level.values.firstWhere(
        (e) => e.toString() == 'Level.$levelStr',
      );
    }

    return Profile(
      map['uuid'] as String,
      map['email'] as String,
      map['username'] as String,
      birthDate,
      map['height'] as int?,
      map['weight'] as double?,
      List<String>.from(map['availability'] as List<dynamic>),
      objective,
      level,
    );
  }

  final String id;
  final String email;
  final String username;

  DateTime birthDate;
  int? height;
  double? weight;

  List<String> availability;
  Objective objective;
  Level level;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'birthDate': birthDate,
      'height': height,
      'weight': weight,
      'availability': availability,
      'objective': objective.toShortString(),
      'level': level.toShortString(),
    };
  }

  String toJson() => json.encode(toMap());

  bool isProfileComplete() {
    if (height != null && weight != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        birthDate,
        height,
        weight,
        availability,
        objective,
        level
      ];

  Profile copyWith({
    String? id,
    String? email,
    String? username,
    DateTime? birthDate,
    int? height,
    double? weight,
    List<String>? availability,
    Objective? objective,
    Level? level,
  }) {
    return Profile(
      id ?? this.id,
      email ?? this.email,
      username ?? this.username,
      birthDate ?? this.birthDate,
      height ?? this.height,
      weight ?? this.weight,
      availability ?? this.availability,
      objective ?? this.objective,
      level ?? this.level,
    );
  }
}
