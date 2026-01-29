import 'package:flutter/material.dart';
import '../services/notifications_api.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  late Future<List<dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = NotificationsApi.getNotifications();
  }

  Color _color(String severity) {
    switch (severity) {
      case 'CRITICAL':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<dynamic>>(
        future: _items,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final n = items[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: _color(n['severity']),
                  ),
                  title: Text(n['title']),
                  subtitle: Text(n['message']),
                  trailing: n['read'] == true
                      ? null
                      : TextButton(
                          onPressed: () async {
                            await NotificationsApi
                                .markRead(n['id']);
                            setState(() {
                              _items = NotificationsApi
                                  .getNotifications();
                            });
                          },
                          child: const Text('Mark read'),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
