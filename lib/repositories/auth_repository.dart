import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:perseus_front_mobile/model/dto/register_dto.dart';

class AuthRepository {
  static const server = 'http://localhost:9090';

  Future<String?> register(RegisterDto registerDto) async {
    final data = registerDto.toJson();

    print(data);

    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      final response = await dio.post<String>(
        '$server/auth/register',
        data: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print(response.data);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return '';
  }

  Future<String?> login(String username, String password) async {
    final body = jsonEncode(
      <String, String>{'username': username, 'password': password},
    );

    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';

    try {
      final response =
          await dio.post<dynamic>('$server/auth/login', data: body);

      if (response.statusCode == 201) {
        final header = response.headers['authorization'];

        if (header != null) {
          final token = header[0].substring(7);

          return token;
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }

    return '';
  }
}
