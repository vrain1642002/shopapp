import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class UserProfileService {
  Future<String?> getAuthToken() async {
    return await TokenService.getToken();
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final authToken = await getAuthToken();
    final response = await http.post(
      Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/nguoidungs/chitiets'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    final authToken = await getAuthToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userId = int.parse(prefs.getString('userId').toString());

    final response = await http.put(
      Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/nguoidungs/chitiets/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(updatedData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }
}
