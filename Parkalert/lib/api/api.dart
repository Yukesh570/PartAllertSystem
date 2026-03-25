import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ApiService {
  final String baseUrl = dotenv.env['BACKEND_API'] ?? '';
  final String brevoUrl = dotenv.env['BREVO_API'] ?? '';
  final String brevoListApi = dotenv.env['BREVO_LIST_API'] ?? '';

  final String apiKey = dotenv.env['BREVO_API_KEY'] ?? '';
  // Future registerUser({
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  //   required String phoneNumber,
  // }) async {
  //   final url = Uri.parse("${baseUrl}api/auth/register/");
  //   final response = await http
  //       .post(
  //         url,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode({
  //           "firstName": firstName,
  //           "lastName": lastName,
  //           "email": email,
  //           "phoneNumber": phoneNumber,
  //         }),
  //       )
  //       .timeout(
  //         const Duration(seconds: 5),
  //         onTimeout: () {
  //           throw Exception("⏳ Request timed out. Please check your internet.");
  //         },
  //       );

  //   print("✅ Registration successful: ${response}");
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = jsonDecode(response.body);
  //     print("✅ Registration successful: ${response.body}");
  //     if (data['token'] != null) {
  //       final box = GetStorage();

  //       await box.write('authToken', data['token']);
  //       final savedToken = box.read('authToken');
  //       if (savedToken != null) {
  //         print("🎉 Token is saved: $savedToken");
  //       } else {
  //         print("⚠️ Token was not saved");
  //       }
  //     }
  //     return data;
  //   } else {
  //     throw Exception("❌ Failed: ${response.statusCode} - ${response.body}");
  //   }
  // }

  // Future createEmailCampaign() async {
  //   const String apiUrl = 'https://api.brevo.com/v3/emailCampaigns';
  //   final Map<String, dynamic> campaignData = {
  //     "name": "Campaign sent via the API",
  //     "subject": "My subject",
  //     "sender": {"name": "From name", "email": "myfromemail@mycompany.com"},
  //     "type": "classic",
  //     "htmlContent":
  //         "<h1>Congratulations! You successfully created ParkAlarm.</h1>",
  //     "recipients": {
  //     },
  //   };
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       "accept": "application/json",
  //       "content-type": "application/json",
  //       "api-key": apiKey,
  //     },
  //     body: jsonEncode(campaignData),
  //   );
  //   if (response.statusCode == 201) {
  //     print("✅ Campaign created successfully!");
  //   } else {
  //     print("❌ Failed to create campaign: ${response.statusCode}");
  //     print("Response body: ${response.body}");
  //   }

  //   return response;
  // }
  // Inside your widget:

  // 1. Add this helper method to your ApiService
  Future<String?> findEmailByPhone(String fullPhoneNumber) async {
    // Use the filter for SMS specifically
    final url = Uri.parse("https://api.brevo.com/v3/contacts/search");

    try {
      final response = await http
          .post(
            url,
            headers: {
              "accept": "application/json",
              "Content-Type": "application/json",
              "api-key": apiKey,
            },
            body: jsonEncode({
              "query":
                  "SMS:\"$fullPhoneNumber\"", // Better query format for search
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Brevo returns contacts in a list called 'contacts'
        if (data['contacts'] != null && data['contacts'].isNotEmpty) {
          String foundEmail = data['contacts'][0]['email'];
          print("🔍 Found phone owner in Brevo: $foundEmail");
          return foundEmail;
        }
      }
    } catch (e) {
      print("⚠️ Search error: $e");
    }
    return null;
  }

  // 2. Update your registerUser to use the search helper
  Future registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? countryCode,
  }) async {
    final code = countryCode ?? "";
    final fullPhone = "$code$phoneNumber";

    print("🚀 Starting Registration Force-Fix for: $fullPhone");

    // --- STEP 1: FIND WHO OWNS THIS SMS ---
    String? emailToCleanup;
    try {
      final searchUrl = Uri.parse("https://api.brevo.com/v3/contacts/search");
      final searchRes = await http
          .post(
            searchUrl,
            headers: {
              "accept": "application/json",
              "Content-Type": "application/json",
              "api-key": apiKey,
            },
            body: jsonEncode({"query": "SMS:\"$fullPhone\""}),
          )
          .timeout(const Duration(seconds: 5));

      if (searchRes.statusCode == 200) {
        final data = jsonDecode(searchRes.body);
        if (data['contacts'] != null && data['contacts'].isNotEmpty) {
          emailToCleanup = data['contacts'][0]['email'];
          print("🔍 Found contact to remove: $emailToCleanup");
        }
      }
    } catch (e) {
      print("⚠️ Search failed: $e");
    }

    // --- STEP 2: DELETE THAT OLD CONTACT ---
    if (emailToCleanup != null) {
      try {
        final deleteUrl = Uri.parse(
          "https://api.brevo.com/v3/contacts/${Uri.encodeComponent(emailToCleanup)}",
        );
        final delRes = await http.delete(
          deleteUrl,
          headers: {"api-key": apiKey},
        );
        print(
          "🧹 Deleted old contact ($emailToCleanup). Status: ${delRes.statusCode}",
        );
        // Wait 1 second for Brevo's database to sync the deletion
        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        print("⚠️ Deletion failed: $e");
      }
    }

    // --- STEP 3: REGISTER THE NEW USER ---
    final url = Uri.parse(brevoUrl);
    final response = await http
        .post(
          url,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "api-key": apiKey,
          },
          body: jsonEncode({
            "email": email,
            "attributes": {
              "FIRSTNAME": firstName,
              "LASTNAME": lastName,
              "SMS": fullPhone,
            },
            "listIds": [23], //michel

            // "listIds": [2],
            "updateEnabled": true,
          }),
        )
        .timeout(const Duration(seconds: 10));

    print("📥 Final Response status: ${response.statusCode}");
    print("📥 Final Response body: ${response.body}");

    return response;
  }

  Future editUser({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    String? countryCode,
  }) async {
    final code = countryCode;
    final url = Uri.parse(brevoUrl);
    print("adasdasdasdasdas${code}${phoneNumber}");
    final response = await http
        .post(
          url,
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "api-key": apiKey,
          },
          body: jsonEncode({
            "email": email,
            "attributes": {
              "FIRSTNAME": firstName,
              "LASTNAME": lastName,
              "SMS": "$code$phoneNumber",
            },
            "updateEnabled": true,
          }),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception("Request timed out. Please check your internet.");
          },
        );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response;
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

  Future createZone({
    required int index,
    required String initialTime,
    required String stopTime,
    required bool isOn,
    required String name,
    required List<LatLng> points,
    // [{lat:.., lng:..}, ...]
  }) async {
    final box = GetStorage();
    final token = box.read('authToken');
    if (token == null) {
      throw Exception("⚠️ No token found. Please login first.");
    }
    final url = Uri.parse("${baseUrl}api/zone/create/");
    final pointList = points
        .map((p) => {"lat": p.latitude, "lng": p.longitude})
        .toList();
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "zones": [
          {
            "index": index,
            "initialTime": initialTime,
            "stopTime": stopTime,
            "isOn": isOn,
            "name": name,
            "points": pointList,
          },
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

  Future<http.Response> deleteUser({required String email}) async {
    // Replace this with your actual Brevo API Key

    // Brevo requires the email to be part of the URL, and it must be URL-encoded
    final url = Uri.parse(
      'https://api.brevo.com/v3/contacts/${Uri.encodeComponent(email)}',
    );

    try {
      final response = await http.delete(
        url,
        headers: {'accept': 'application/json', 'api-key': apiKey},
      );

      return response;
    } catch (e) {
      print("Error deleting user from Brevo: $e");
      rethrow;
    }
  }
}
