import 'dart:convert';
import 'package:adazal_app/models/http_exeption.dart';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyDWxrVV2MmIwgkp4Q992Gd9GX-or_4YfiI';

class AuthRepository {
  Future<Map<String, dynamic>> authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey';

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final body = json.decode(response.body);
      if (body['error'] != null) {
        throw HttpExeption(body['error']['message']);
      }
      print(body);
      return body;
    } catch (error) {
      throw error;
    }
  }
}
