import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/services/token_storage.dart';
import '../models/asset.dart';

class PortfolioApi {
  static const String baseUrl = 'http://localhost:3000';

  /// ✅ Get all assets (STRONGLY TYPED)
  static Future<List<Asset>> getAssets() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/portfolio/assets'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load assets');
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Asset.fromJson(e)).toList();
  }

  /// Add asset
static Future<void> addAsset(Map<String, dynamic> payload) async {
  final token = await TokenStorage.getToken();

  if (token == null || token.isEmpty) {
    throw Exception('JWT token missing');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/portfolio/assets'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(payload),
  );

 print('ADD ASSET STATUS: ${response.statusCode}');
print('ADD ASSET BODY: ${response.body}');


  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
        'Backend error ${response.statusCode}: ${response.body}');
  }
}


  /// Portfolio summary
 static Future<Map<String, dynamic>> getSummary() async {
  final token = await TokenStorage.getToken();

  if (token == null || token.isEmpty) {
    throw Exception('JWT missing');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/portfolio/summary'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
      'Failed to load summary ${response.statusCode}',
    );
  }

  return jsonDecode(response.body);
}

  //----
  static Future<void> deleteAsset(String assetId) async {
  final token = await TokenStorage.getToken();

  final response = await http.delete(
    Uri.parse('$baseUrl/portfolio/assets/$assetId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to delete asset');
  }
}

static Future<dynamic> getRawAssets() async {
  final token = await TokenStorage.getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/portfolio/assets'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
        'HTTP ${response.statusCode}: ${response.body}');
  }

  return jsonDecode(response.body);
}
//--
static Future<Map<String, dynamic>> getAnalysis() async {
  final token = await TokenStorage.getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/portfolio/analysis'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to load analysis');
  }

  return jsonDecode(response.body);
}
//----
static Future<List<dynamic>> getMaturities() async {
  final token = await TokenStorage.getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/portfolio/maturities'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to load maturities');
  }

  return jsonDecode(response.body);
}
//-----
static Future<List<dynamic>> getRecommendations() async {
  final token = await TokenStorage.getToken();

  final response = await http.get(
    Uri.parse('$baseUrl/portfolio/recommendations'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception('Failed to load recommendations');
  }

  return jsonDecode(response.body);
}

}

