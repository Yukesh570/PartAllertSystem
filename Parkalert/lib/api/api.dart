import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
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
    print("✅ Registration successful: ${response}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print("✅ Registration successful: ${response.body}");
      if (data['token'] != null) {
        final box = GetStorage();

        await box.write('authToken', data['token']);
        final savedToken = box.read('authToken');
        if (savedToken != null) {
          print("🎉 Token is saved: $savedToken");
        } else {
          print("⚠️ Token was not saved");
        }
      }
      return {data};
    } else {
      print("❌ Failed: ${response.statusCode} - ${response.body}");
    }
  }

  Future createHistory({
    required int index,
    required double lat,
    required double lng,
    required String time,
    required String name,
  }) async {
    final box = GetStorage();
    final token = box.read('authToken');
    if (token == null) {
      throw Exception("⚠️ No token found. Please login first.");
    }
    final url = Uri.parse("${baseUrl}api/history/create/");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "histories": [
          {"index": index, "lat": lat, "lng": lng, "time": time, "name": name},
        ],
      }),
    );
    print("Response history status: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("❌ Failed: ${response.statusCode} - ${response.body}");
    }
  }
}
