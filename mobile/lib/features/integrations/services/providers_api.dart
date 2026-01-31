import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/services/token_storage.dart';

class ProvidersApi {
  static Future<List<dynamic>> getConsents() async {
    final token = await TokenStorage.getToken();

    print('GET CONSENTS → ${ApiConfig.baseUrl}/v3/consents');

    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v3/consents'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Get consents failed: ${res.statusCode} ${res.body}',
      );
    }

    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getSyncJobs() async {
    final token = await TokenStorage.getToken();

    print('GET SYNC JOBS → ${ApiConfig.baseUrl}/v3/sync-jobs');

    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v3/sync-jobs'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Get sync jobs failed: ${res.statusCode} ${res.body}',
      );
    }

    return jsonDecode(res.body);
  }

  static Future<void> grantConsent(String providerId) async {
    final token = await TokenStorage.getToken();

    print('GRANT CONSENT → ${ApiConfig.baseUrl}/v3/consents/grant');
    print('PROVIDER → $providerId');

    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v3/consents/grant'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'providerId': providerId,
        'scopes': ['ACCOUNTS', 'FD'],
        'ttlDays': 90,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Grant consent failed: ${res.statusCode} ${res.body}',
      );
    }
  }

  static Future<void> revokeConsent(String consentId) async {
    final token = await TokenStorage.getToken();

    print(
        'REVOKE CONSENT → ${ApiConfig.baseUrl}/v3/consents/$consentId/revoke');

    final res = await http.post(
      Uri.parse(
          '${ApiConfig.baseUrl}/v3/consents/$consentId/revoke'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'Revoke consent failed: ${res.statusCode} ${res.body}',
      );
    }
  }

  static Future<void> sync(String providerId) async {
    final token = await TokenStorage.getToken();

    print(
        'SYNC → ${ApiConfig.baseUrl}/v3/integrations/sync?providerId=$providerId');

    final res = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/v3/integrations/sync?providerId=$providerId',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Sync failed: ${res.statusCode} ${res.body}',
      );
    }
  }
}

