import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../auth/services/token_storage.dart';

class NotificationsApi {
  /// GET all notifications
  static Future<List<dynamic>> getNotifications() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v2/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load notifications');
    }

    return jsonDecode(response.body);
  }

  /// MARK notification as read
  static Future<void> markRead(String id) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v2/notifications/$id/read'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  /// GET unread count
  static Future<int> getUnreadCount() async {
    final items = await getNotifications();
    return items.where((n) => n['read'] == false).length;
  }
}
