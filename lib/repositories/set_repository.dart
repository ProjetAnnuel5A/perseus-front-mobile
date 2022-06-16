import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/common/interceptor/jwt_interceptor.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/dto/validate_set_dto.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/model/set.dart';

class SetRepository {
  SetRepository() {
    _baseUrl = dotenv.env['sport_api'] ?? 'locahost:3000';
    _dio.options.headers['content-Type'] = 'application/json';
  }
  String? _baseUrl;
  final Dio _dio = Dio();
  final _storage = SecureStorage();

  Future<Set?> validateSet(String setId, List<Exercise> exercises) async {
    await checkToken();

    final data = ValidateSetDto(exercises).toJson();

    try {
      final response = await _dio.patch<String>(
        '$_baseUrl/v1/sets/validate/$setId',
        data: data,
      );

      if (response.statusCode == 200 && response.data != null) {
        final setMap = jsonDecode(response.data!) as Map<String, dynamic>;
        final set = Set.fromMap(setMap);

        return set;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e, stacktrace) {
      print('$e\n$stacktrace');
    }

    return null;
  }

  Future<Set?> getById(String setId) async {
    await checkToken();

    try {
      final response = await _dio.get<String>(
        '$_baseUrl/v1/sets/$setId',
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

  Future<void> checkToken() async {
    if (_dio.interceptors.isEmpty) {
      final token = await _storage.getToken();

      if (token != null) {
        _dio.interceptors.add(CustomInterceptors(token));
      }
    }
  }
}
