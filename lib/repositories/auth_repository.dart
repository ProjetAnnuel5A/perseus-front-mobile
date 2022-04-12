import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:perseus_front_mobile/model/dao/register_dao.dart';

class AuthRepository {

  static const server = 'http://localhost:9090';

  Future<String?> register() async {
    final data =
        RegisterDao('username14', 'username14@email.com', 'azerA123!').toJson();

    final dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      final response = await dio.post<RegisterDao>(
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

        // TODO Check token validity
        if (header != null) {
          final token = header[0].substring(7);
          print(token);

          final decodedToken = JwtDecoder.decode(token);
          print(decodedToken);

          final isTokenExpired = JwtDecoder.isExpired(token);

          if(isTokenExpired) {
            // TODO handle use case
          }

          return 'token';
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
