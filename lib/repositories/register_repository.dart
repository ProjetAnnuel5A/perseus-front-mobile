import 'dart:convert';

import 'package:http/http.dart' as http;

class RegisterRepository {
  Future<String?> register() async {
    const server = 'localhost:9090';
    final body = jsonEncode(<String, String>{
      'username': 'userName',
      'email': 'username@email.com',
      'password': 'azerA123!'
    });

    final url = Uri.http(server, '/auth/register');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      print(response.body);
      // var jsonResponse =
      //     convert.jsonDecode(response.body) as Map<String, dynamic>;
      // var itemCount = jsonResponse['totalItems'];
      // print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return '';
  }
}
