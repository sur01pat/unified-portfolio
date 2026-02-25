import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';

class AuthApi {

  // ============================
  // ADD THIS (debug helper only)
  // ============================
  static String? lastOtp; // stores OTP for debug display
  // ============================

  /// Send OTP
  static Future<void> sendOtp(String mobileNumber) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mobileNumber': mobileNumber,
      }),
    );
    // --------------------------------------------------
    // ADD THIS (capture OTP if backend returns it)
    // --------------------------------------------------
    try {
      final data = jsonDecode(response.body);
      lastOtp = data['otp']?.toString();
    } catch (_) {}
    // --------------------------------------------------

    //print("OTP BASE URL => ${ApiConfig.baseUrl}");
    //print("SEND OTP URL => ${ApiConfig.baseUrl}/auth/send-otp");

    // ============================
    // ADD THIS (capture OTP if backend sends it)
    // ============================
    try {
      final data = jsonDecode(response.body);
      if (data['otp'] != null) {
        lastOtp = data['otp'].toString();
      }
    } catch (_) {}
    // ============================

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

