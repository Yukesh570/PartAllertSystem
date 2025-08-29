import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.env['BACKEND_API'] ?? '';

  Future registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final url = Uri.parse("${baseUrl}api/auth/register/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {response.body};
    } else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
    }
  }
}
