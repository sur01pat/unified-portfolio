import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/services/token_storage.dart';

class AccountsApi {
  static const baseUrl = 'http://localhost:3000';

  static Future<List<dynamic>> getAccounts() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/v2/accounts'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load accounts');
    }

    return jsonDecode(response.body);
  }

  static Future<void> seedAccounts() async {
    final token = await TokenStorage.getToken();

    await http.post(
      Uri.parse('$baseUrl/v2/accounts/seed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<void> syncBank() async {
    final token = await TokenStorage.getToken();
    await http.post(
      Uri.parse('$baseUrl/v2/ingest/bank'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<void> syncBroker() async {
    final token = await TokenStorage.getToken();
    await http.post(
      Uri.parse('$baseUrl/v2/ingest/broker'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}
