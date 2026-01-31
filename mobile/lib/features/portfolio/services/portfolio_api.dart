import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/services/token_storage.dart';
import '../models/asset.dart';

class PortfolioApi {
  /// Get all assets (strongly typed)
  static Future<List<Asset>> getAssets() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT token missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/assets'),
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
      Uri.parse('${ApiConfig.baseUrl}/portfolio/assets'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Backend error ${response.statusCode}: ${response.body}',
      );
    }
  }

  /// Portfolio summary
  static Future<Map<String, dynamic>> getSummary() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/summary'),
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

  /// Delete asset
  static Future<void> deleteAsset(String assetId) async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT missing');
    }

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/assets/$assetId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete asset');
    }
  }

  /// Portfolio analysis
  static Future<Map<String, dynamic>> getAnalysis() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/analysis'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load analysis');
    }

    return jsonDecode(response.body);
  }

  /// Maturities
  static Future<List<dynamic>> getMaturities() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/maturities'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load maturities');
    }

    return jsonDecode(response.body);
  }

  /// Recommendations
  static Future<List<dynamic>> getRecommendations() async {
    final token = await TokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('JWT missing');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/portfolio/recommendations'),
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


