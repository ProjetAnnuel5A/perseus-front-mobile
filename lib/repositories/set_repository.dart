import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/dto/validate_set_dto.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';

class SetRepository {
  static const server = 'http://localhost:3000';

  Future<Set?> validateSet(String setId, List<Exercise> exercises) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final data = ValidateSetDto(exercises).toJson();

    try {
      final response = await dio.patch<String>(
        '$server/v1/sets/validate/$setId',
        data: data,
      );

      if (response.statusCode == 200 && response.data != null) {
        final setMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final set = Set.fromMap(setMap);

        return set;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<Set?> getById(String setId) async {
    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      final response = await dio.get<String>(
        '$server/v1/sets/$setId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final setMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final set = Set.fromMap(setMap);

        return set;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
