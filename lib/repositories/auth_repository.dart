import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perseus_front_mobile/model/dto/register_dto.dart';

class AuthRepository {
  AuthRepository() {
    server = dotenv.env['login_api'] ?? 'locahost:9090';
  }

  String? server;

  Future<String?> register(RegisterDto registerDto) async {
    final data = registerDto.toJson();

    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      final response = await dio.post<String>(
        '$server/auth/register',
        data: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print(response.data);
        return 'ok';
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

      if (e is DioError) {
        if (e.response != null && e.response!.statusCode == 404) {
          return null;
        }
      }
    }

    return '';
  }
}
