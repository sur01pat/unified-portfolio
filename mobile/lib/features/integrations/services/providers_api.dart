import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../auth/services/token_storage.dart';

class ProvidersApi {
  static String get baseUrl {
    // ✅ Platform-safe localhost handling
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://127.0.0.1:3000';
  }

  static Future<List<dynamic>> getConsents() async {
    final token = await TokenStorage.getToken();

    print('GET CONSENTS → $baseUrl/v3/consents');
    print('TOKEN → $token');

    final res = await http.get(
      Uri.parse('$baseUrl/v3/consents'),
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

    print('GET SYNC JOBS → $baseUrl/v3/sync-jobs');

    final res = await http.get(
      Uri.parse('$baseUrl/v3/sync-jobs'),
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

  /// ✅ GRANT CONSENT (DEBUG ENABLED)
  static Future<void> grantConsent(String providerId) async {
    final token = await TokenStorage.getToken();

    print('GRANT CONSENT → $baseUrl/v3/consents/grant');
    print('PROVIDER → $providerId');
    print('TOKEN → $token');

    final res = await http.post(
      Uri.parse('$baseUrl/v3/consents/grant'),
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

    print('GRANT RESPONSE → ${res.statusCode}');
    print('GRANT BODY → ${res.body}');

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(
        'Grant consent failed: ${res.statusCode} ${res.body}',
      );
    }
  }
//----
static Future<void> revokeConsent(String consentId) async {
  final token = await TokenStorage.getToken();

  print(
      'REVOKE CONSENT → $baseUrl/v3/consents/$consentId/revoke');

  final res = await http.post(
    Uri.parse('$baseUrl/v3/consents/$consentId/revoke'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  // ✅ ACCEPT 200 OR 201
  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(
      'Revoke consent failed: ${res.statusCode} ${res.body}',
    );
  }
}

//---
  static Future<void> sync(String providerId) async {
    final token = await TokenStorage.getToken();

    print('SYNC → $baseUrl/v3/integrations/sync?providerId=$providerId');

    final res = await http.get(
      Uri.parse(
        '$baseUrl/v3/integrations/sync?providerId=$providerId',
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

