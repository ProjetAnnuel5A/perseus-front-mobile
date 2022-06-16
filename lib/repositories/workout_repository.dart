import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/interceptor/jwt_interceptor.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/workout.dart';

class WorkoutRepository {
  WorkoutRepository() {
    _baseUrl = dotenv.env['sport_api'] ?? 'locahost:3000';
    _dio.options.headers['content-Type'] = 'application/json';
  }

  String? _baseUrl;
  final Dio _dio = Dio();
  final _storage = SecureStorage();

  Future<List<Workout>> getAllByUserId() async {
    try {
      await checkToken();

      final userId = await _storage.getUserId();

      final response = await _dio.get<String>(
        '$_baseUrl/v1/workouts/byUserId/$userId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final workouts = <Workout>[];
        final dataList = jsonDecode(response.data!) as List;

        for (final element in dataList) {
          final map = element as Map<String, dynamic>;
          final workout = Workout.fromMap(map);

          workouts.add(workout);
        }

        return workouts;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  Future<void> checkToken() async {
    if (_dio.interceptors.isEmpty) {
      final token = await _storage.getToken();

      if (token != null) {
        _dio.interceptors.add(CustomInterceptors(token));
      }
    }
  }
}
