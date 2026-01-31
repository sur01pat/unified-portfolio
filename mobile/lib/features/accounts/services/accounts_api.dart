import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/services/token_storage.dart';

class AccountsApi {
  static Future<List<dynamic>> getAccounts() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v2/accounts'),
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

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v2/accounts/seed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to seed accounts');
    }
  }

  static Future<void> syncBank() async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v2/ingest/bank'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Bank sync failed');
    }
  }

  static Future<void> syncBroker() async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v2/ingest/broker'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Broker sync failed');
    }
  }
}
