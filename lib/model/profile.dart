// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile(this.id, this.email, this.username);

  final String id;
  final String email;
  final String username;

  // String birthDate;
  // String height;
  // String weight;
  // String objective;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      map['uuid'] as String,
      map['email'] as String,
      map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, email, username];

  Profile copyWith({
    String? id,
    String? email,
    String? username,
  }) {
    return Profile(
      id ?? this.id,
      email ?? this.email,
      username ?? this.username,
    );
  }
}
