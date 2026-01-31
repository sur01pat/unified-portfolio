import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

class AuthApi {
  /// Send OTP
  static Future<void> sendOtp(String mobileNumber) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobileNumber': mobileNumber,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Failed to send OTP. Status: ${response.statusCode}',
      );
    }
  }

  /// Verify OTP
  static Future<String> verifyOtp(
      String mobileNumber, String otp) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobileNumber': mobileNumber,
        'code': otp,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'OTP verification failed. Status: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);
    return data['accessToken'];
  }
}
